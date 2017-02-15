module Sportradar
  module Api
    module Basketball
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :clock, :duration, :attendance, :team_stats, :player_stats, :changes, :media_timeouts

        attr_accessor :period
        @all_hash = {}
        # def self.new(data, **opts)
        #   existing = @all_hash[data['id']]
        #   if existing
        #     existing.update(data, **opts)
        #     existing
        #   else
        #     @all_hash[data['id']] = super
        #   end
        # end
        # def self.all
        #   @all_hash.values
        # end

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          # @season   = opts[:season]
          @updates  = {}
          @changes  = {}
          
          @score          = {}
          @team_stats     = {}
          @player_stats   = {}
          @scoring_raw    = Scoring.new(data, game: self)
          @teams_hash     = {}
          @periods_hash   = {}
          @home_points    = nil
          @away_points    = nil
          @home_id        = nil
          @away_id        = nil
          
          @id = data['id']
          
          update(data, **opts)
        end
        def timeouts
          {}
        end

        def tied?
          @score[away_id].to_i == @score[home_id].to_i
        end
        def points(team_id)
          team_id.is_a?(Symbol) ? @score[@team_ids[team_id]].to_i : @score[team_id].to_i
        end
        def stats(team_id)
          team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]].to_i : @team_stats[team_id].to_i
        end

        def scoring
          @scoring_raw.scores
        end
        def update_score(score)
          @score.merge!(score)
        end
        def update_stats(team, stats)
          @team_stats.merge!(team.id => stats.merge!(team: team))
        end
        def update_player_stats(player, stats)
          @player_stats.merge!(player.id => stats.merge!(player: player))
        end

        def parse_score(data)
          update_score(data.dig('home', 'id') => data.dig('home', 'points').to_i)
          update_score(data.dig('away', 'id') => data.dig('away', 'points').to_i)
        end
        def clock_seconds
          return unless @clock
          m,s = @clock.split(':')
          m.to_i * 60 + s.to_i
        end

        def update(data, source: nil, **opts)
          # via pbp
          @title        = data['title']                 if data['title']
          @status       = data['status']                if data['status']
          @coverage     = data['coverage']              if data['coverage']
          @home_id      = data['home_team'] || data.dig('home', 'id')   if data['home_team'] || data.dig('home', 'id')
          @away_id      = data['away_team'] || data.dig('away', 'id')   if data['away_team'] || data.dig('away', 'id')
          @home_points  = data['home_points'].to_i      if data['home_points']
          @away_points  = data['away_points'].to_i      if data['away_points']

          @scheduled    = Time.parse(data["scheduled"]) if data["scheduled"]
          @venue        = Venue.new(data['venue']) if data['venue']
          @broadcast    = Broadcast.new(data['broadcast']) if data['broadcast']
          @home         = team_class.new(data['home'], api: api, game: self) if data['home']
          @away         = team_class.new(data['away'], api: api, game: self) if data['away']

          @duration     = data['duration']              if data['duration']
          @clock        = data['clock']                 if data['clock']
          @attendance   = data['attendance']            if data['attendance']
          @lead_changes = data['lead_changes']          if data['lead_changes']
          @times_tied   = data['times_tied']            if data['times_tied']

          @team_ids     = { home: @home_id, away: @away_id}

          update_score(@home_id => @home_points.to_i) if @home_points
          update_score(@away_id => @away_points.to_i) if @away_points
          parse_score(data['scoring']) if data['scoring']
          @scoring_raw.update(data, source: source)

          create_data(@teams_hash, data['team'], klass: team_class, api: api, game: self) if data['team']
        end

        def home
          @teams_hash[@home_id] || @home
        end

        def away
          @teams_hash[@away_id] || @away
        end

        def box
          @box ||= get_box
        end
        def pbp
          if !future? && periods.empty?
            get_pbp
          end
          @pbp ||= periods
        end
        def plays
          periods.flat_map(&:plays)
        end
        def plays_by_type(play_type, *types)
          if types.empty?
            plays.grep(Play.subclass(play_type.delete('_')))
          else
            play_classes = [play_type, *types].map { |type| Play.subclass(type.delete('_')) }
            plays.select { |play| play_classes.any? { |klass| play.kind_of?(klass) } }
          end
        end
        def summary
          @summary ||= get_summary
        end
        alias :events :plays

        def periods
          @periods_hash.values
        end


        # tracking updates
        def remember(key, object)
          @updates[key] = object&.dup
        end
        def not_updated?(key, object)
          @updates[key] == object
        end
        def changed?(key)
          @changes[key]
        end
        def check_newness(key, new_object)
          @changes[key] = !not_updated?(key, new_object)
          remember(key, new_object)
        end

        # url paths
        def path_base
          "games/#{ id }"
        end
        def path_box
          "#{ path_base }/boxscore"
        end
        def path_pbp
          "#{ path_base }/pbp"
        end
        def path_summary
          "#{ path_base }/summary"
        end

        # status helpers
        def postponed?
          'postponed' == status
        end
        def future?
          ['scheduled', 'delayed', 'created', 'time-tbd'].include? status
        end
        def started?
          ['inprogress', 'halftime', 'delayed'].include? status
        end
        def finished?
          ['complete', 'closed'].include? status
        end
        def completed?
          'complete' == status
        end
        def closed?
          'closed' == status
        end

        # data retrieval

        def get_box
          data = api.get_data(path_box)
          ingest_box(data)
        end

        def ingest_box(data)
          update(data, source: :box)
          @period = data.delete(period_name).to_i
          check_newness(:box, @clock)
          data
        end

        def queue_pbp
          url, headers, options, timeout = api.get_request_info(path_pbp)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_pbp)}
        end

        def get_pbp
          data = api.get_data(path_pbp)
          ingest_pbp(data)
        end

        def ingest_pbp(data)
          period_name = 'periods'
          update(data, source: :pbp)
          period_data = if data[period_name] && !data[period_name].empty?
            @period = data[period_name].last['sequence'].to_i
            pers = data[period_name]
            pers.is_a?(Array) && (pers.size == 1) ? pers[0] : pers
          else
            @period = nil
            []
          end
          if data['overtime']
            extra_periods = data['overtime'].is_a?(Hash) ? [data['overtime']] : data['overtime']
            period_data.concat(extra_periods)
          end
          set_pbp(period_data)
          @pbp = @periods_hash.values
          check_newness(:pbp, plays.last)
          check_newness(:score, @score)
          data
        end

        def get_summary
          data = api.get_data(path_summary)
          ingest_summary(data)
        end

        def queue_summary
          url, headers, options, timeout = api.get_request_info(path_summary)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_summary)}
        end

        def ingest_summary(data)
          update(data, source: :summary)
          @period = data.delete(period_name).to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        end

        def set_pbp(data)
          create_data(@periods_hash, data, klass: period_class, api: api, game: self)
          @plays  = nil # to clear empty array empty
          @periods_hash
        end

        # @abstract Subclass is expected to implement #period_class
        # @!method period_class
        #    The class used for game periods

        # @abstract Subclass is expected to implement #period_name
        # @!method period_name
        #    The string name used for game periods

        # @abstract Subclass is expected to implement #api
        # @!method api
        #    The base for the requests needed for a subclass

      end
    end
  end
end
