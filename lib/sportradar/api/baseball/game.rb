module Sportradar
  module Api
    module Baseball
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance, :team_stats, :player_stats, :changes

        attr_accessor :inning

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
          @innings_hash   = {}
          @home_runs      = nil
          @away_runs      = nil
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
        def runs(team_id)
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
          update_score(data.dig('home', 'id') => data.dig('home', 'runs').to_i)
          update_score(data.dig('away', 'id') => data.dig('away', 'runs').to_i)
        end

        def update(data, source: nil, **opts)
          # via pbp
          @title        = data['title']                 if data['title']
          @status       = data['status']                if data['status']
          @coverage     = data['coverage']              if data['coverage']
          @day_night    = data['day_night']             if data['day_night']
          @game_number  = data['game_number']           if data['game_number']
          @home_id      = data['home_team'] || data.dig('home', 'id')   if data['home_team'] || data.dig('home', 'id')
          @away_id      = data['away_team'] || data.dig('away', 'id')   if data['away_team'] || data.dig('away', 'id')
          # @home_runs    = data['home_runs'].to_i      if data['home_runs']
          # @away_runs    = data['away_runs'].to_i      if data['away_runs']

          @scheduled    = Time.parse(data["scheduled"]) if data["scheduled"]
          @venue        = Venue.new(data['venue']) if data['venue']
          @broadcast    = Broadcast.new(data['broadcast']) if data['broadcast']
          @home         = Team.new(data['home'], api: api, game: self) if data['home']
          @away         = Team.new(data['away'], api: api, game: self) if data['away']

          @duration     = data['duration']              if data['duration']
          @attendance   = data['attendance']            if data['attendance']

          # @lead_changes = data['lead_changes']          if data['lead_changes']
          # @times_tied   = data['times_tied']            if data['times_tied']

          # @team_ids     = { home: @home_id, away: @away_id}

          # update_score(@home_id => @home_runs.to_i) if @home_runs
          # update_score(@away_id => @away_runs.to_i) if @away_runs
          # parse_score(data['scoring']) if data['scoring']
          # @scoring_raw.update(data, source: source)

          # create_data(@teams_hash, data['team'], klass: Team, api: api, game: self) if data['team']
        end

        def home
          @teams_hash[@home_id] || @home
        end

        def away
          @teams_hash[@away_id] || @away
        end

        def leading_team_id
          return nil if score.values.uniq.size == 1
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
          if !future? && innings.empty?
            get_pbp
          end
          @pbp ||= innings
        end

        def at_bats
          innings.flat_map(&:at_bats)
        end

        def pitches
          at_bats.flat_map(&:pitches)
        end

        def summary
          @summary ||= get_summary
        end

        def innings
          @innings_hash.values
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
          data = data['game']
          update(data, source: :box)
          check_newness(:box, @clock)
          data
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
          data = data['game']
          update(data, source: :pbp)
          # @pbp = @innings_hash.values
          innings = data['innings'].each { |inning| inning['id'] = "#{data['id']}-#{inning['number']}" }
          create_data(@innings_hash, innings, klass: Inning, api: api, game: self) if data['innings']
          check_newness(:pbp, pitches.last)
          check_newness(:score, @score)
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
          data = data['game']
          update(data, source: :summary)
          @inning = data.delete('inning').to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        end

        def set_pbp(data)
          create_data(@innings_hash, data, klass: inning_class, api: api, game: self)
          @innings_hash
        end

        def api
          @api || Sportradar::Api::Baseball::Mlb.new
        end
      end
    end
  end
end

__END__

# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
# res = mlb.get_schedule;
# g = mlb.games.first
g = Sportradar::Api::Baseball::Game.new('id' => "8cd71519-429f-4461-88a2-8a0e134eb89b")
g.get_summary
g.get_pbp
g.get_box # probably not as useful as summary
