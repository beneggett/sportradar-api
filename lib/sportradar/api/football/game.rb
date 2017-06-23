module Sportradar
  module Api
    module Football
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance, :team_stats, :player_stats, :changes, :lineup, :week

        attr_reader :week_number, :year, :type

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          # @week     = opts[:week]

          @scoring_raw = Scoring.new(data, game: self)

          @updates  = {}
          @changes  = {}

          @teams_hash = {}
          @team_stats = {}
          @player_stats = {}

          @quarters_hash = {}
          @score = {}

          update(data, **opts)
        end

        def timeouts
          {}
        end

        def summary_stat(team_id, stat_name)
          scoring.dig(team_id, stat_name)
        end
        def stats(team_id)
          team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]] : @team_stats[team_id]
        end

        def update_stats(team, stats)
          @team_stats.merge!(team.id => stats)
        end
        def update_player_stats(player, stats)
          @player_stats.merge!(player.id => stats.merge!(player: player))
        end

        def parse_score(data)
          # home_id = data.dig('home', 'id')
          # away_id = data.dig('away', 'id')
          # rhe = {
          #   'runs'    => { home_id => data.dig('home', 'runs'), away_id => data.dig('away', 'runs')},
          #   'hits'    => { home_id => data.dig('home', 'hits'), away_id => data.dig('away', 'hits')},
          #   'errors'  => { home_id => data.dig('home', 'errors'), away_id => data.dig('away', 'errors')},
          # }
          # @scoring_raw.update(rhe, source: :rhe)
          # update_score(home_id => data.dig('home', 'runs'))
          # update_score(away_id => data.dig('away', 'runs'))
        end

        def update(data, source: nil, **opts)
          @id           = data['id']
          # @year          = data['year'] || @week&.season.year
          # @type          = data['type'] || @week&.season.type
          # @week_number   = data['week'] || @week&.sequence

          @week_number = data['week_number']  || week&.number || opts[:week]&.number  || @week_number
          @year        = data['year']         || week&.year   || opts[:week]&.year    || @year
          @type        = data['type']         || week&.type   || opts[:week]&.type    || @type


          @coverage      = data['coverage']
          @scheduled     = Time.parse(data["scheduled"]) if data["scheduled"]
          update_teams(data)
          @status        = data['status']
          @home_rotation = data['home_rotation']
          @away_rotation = data['away_rotation']
          @neutral_site  = data['neutral_site']
          @home_points   = data['home_points']
          @away_points   = data['away_points']
          @venue         = data['venue']
          # @venue         = Sportradar::Api::Football::Venue.new(data["venue"]) if data["venue"]
          @weather       = data['weather']
          @broadcast     = data['broadcast']
          @attendance    = data['attendance']
          # @links         = data['links'] ? structure_links(data['links']) : {}

          @teams_hash    = { @home.id => @home, @away.id => @away } if @home && @away
          @team_ids      = { home: (@home&.id || home_alias), away: (@away&.id || away_alias) }

          @scoring_raw.update(data, source: source)

          create_data(@teams_hash, data['team'], klass: team_class, api: api, game: self) if data['team']
        end

        def update_teams(data)
          @home          = team_class.new(data['home_team'], api: api, game: self) if data['home_team'].is_a?(Hash)
          @away          = team_class.new(data['away_team'], api: api, game: self) if data['away_team'].is_a?(Hash)
          @home_alias    = data['home'] if data['home'].is_a?(String) # this might actually be team ID and not alias. check in NFL
          @away_alias    = data['away'] if data['away'].is_a?(String) # this might actually be team ID and not alias. check in NFL
        end

        # def update_from_team(id, data)
        # end

        def home
          @teams_hash[@home_id] || @home
        end

        def home_alias
          @home_alias || @home&.alias
        end

        def away
          @teams_hash[@away_id] || @away
        end

        def away_alias
          @away_alias || @away&.alias
        end

        def tied?
          @score[away_id].to_i == @score[home_id].to_i
        end
        def scoring
          @scoring_raw.scores
        end
        def update_score(score)
          @score.merge!(score)
        end

        def leading_team_id
          return nil if tied?
          score.max_by(&:last).first
        end

        def leading_team
          @teams_hash[leading_team_id] || (@away_id == leading_team_id && away) || (@home_id == leading_team_id && home)
        end

        def team(team_id)
          @teams_hash[team_id]
        end

        def assign_home(team)
          @home_id = team.id
          @teams_hash[team.id] = team
        end

        def assign_away(team)
          @away_id = team.id
          @teams_hash[team.id] = team
        end

        def box
          @box ||= get_box
        end

        def pbp
          if !future? && quarters.empty?
            get_pbp
          end
          @pbp ||= quarters
        end

        def drives
          quarters.flat_map(&:drives).compact
        end

        def plays
          drives.flat_map(&:plays).compact
        end

        def events
          drives.flat_map(&:events).compact
        end

        # def summary
        #   @summary ||= get_summary
        # end

        def quarters
          @quarters_hash.values
        end
        def half_quarters
          quarters.flat_map(&:half_quarters)
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

        # status helpers
        def postponed?
          'postponed' == status
        end

        def unnecessary?
          'unnecessary' == status
        end

        def cancelled?
          ['unnecessary', 'postponed'].include? status
        end

        def future?
          ['scheduled', 'delayed', 'created', 'time-tbd'].include? status
        end

        def started?
          ['inprogress', 'wdelay', 'delayed'].include? status
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

        # url path helpers
        def path_box
          "#{ path_base }/boxscore"
        end
        def path_extended_box
          "#{ path_base }/extended-boxscore"
        end
        def path_pbp
          "#{ path_base }/pbp"
        end
        def path_roster
          "#{ path_base }/roster"
        end
        def path_statistics
          "#{ path_base }/statistics"
        end
        def path_summary
          "#{ path_base }/summary"
        end

        # data retrieval

        def get_box
          data = api.get_data(path_box)
          ingest_box(data)
        end

        def ingest_box(data)
          data = data
          update(data, source: :box)
          check_newness(:box, @clock)
          data
        # rescue => e
        #   binding.pry
        end

        def queue_pbp
          url, headers, options, timeout = api.get_request_info(path_pbp)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_pbp)}
        end

        def get_pbp
          data = api.get_data(path_pbp);
          ingest_pbp(data)
        end

        def ingest_pbp(data)
          data = data
          update(data, source: :pbp)
          create_data(@quarters_hash, data[period_key], klass: quarter_class, identifier: 'number', api: api, game: self) if data[period_key]
          check_newness(:pbp, plays.last&.description)
          check_newness(:score, @score)
          @pbp = @quarters_hash.values
          data
        # rescue => e
        #   binding.pry
        end

        def period_key
          'quarters'
        end

        def get_statistics
          data = api.get_data(path_statistics)
          ingest_statistics(data)
        end

        def queue_statistics
          url, headers, options, timeout = api.get_request_info(path_statistics)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_statistics)}
        end

        def ingest_statistics(data)
          update(data, source: :statistics)
          check_newness(:statistics, @clock)
          data
        # rescue => e
        #   binding.pry
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
          data = data
          update(data, source: :summary)
          @quarter = data.delete('quarter').to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        rescue => e
          binding.pry
        end

        def quarter_class
          Sportradar::Api::Football::Quarter
        end

      end
    end
  end
end
