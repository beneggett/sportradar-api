module Sportradar
  module Api
    module Football
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance, :team_stats, :player_stats, :changes, :lineup

        attr_reader :inning, :half, :outs, :bases, :pitchers, :final, :rescheduled, :inning_over
        attr_reader :outcome, :count
        DEFAULT_BASES = { '1' => nil, '2' => nil, '3' => nil }

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @week     = opts[:week]

          @quarters_hash = {}

          update(data, **opts)
        end
        def lineup
          @lineup ||= Lineup.new({}, game: self)
        end

        def timeouts
          {}
        end

        def summary_stat(team_id, stat_name)
          scoring.dig(team_id, stat_name)
        end
        def stats(team_id)
          team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]].to_i : @team_stats[team_id].to_i
        end

        def update_stats(team, stats)
          @team_stats.merge!(team.id => stats.merge!(team: team))
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
          @year          = response['year'] || @week&.season.year
          @type          = response['type'] || @week&.season.type
          @week_number   = response['week'] || @week&.sequence
          @coverage      = response['coverage']
          @scheduled     = Time.parse(response["scheduled"]) if response["scheduled"]
          @home          = Team.new(response['home'], api: api, game: self)
          @away          = Team.new(response['away'], api: api, game: self)
          @status        = response['status']
          @home_rotation = response['home_rotation']
          @away_rotation = response['away_rotation']
          @neutral_site  = response['neutral_site'] == 'true'
          @home_points   = response['home_points']
          @away_points   = response['away_points']
          @venue         = response['venue']
          # @venue         = Sportradar::Api::Football::Venue.new(response["venue"]) if response["venue"]
          @weather       = response['weather']
          @broadcast     = response['broadcast']
          @links         = structure_links response.dig('links', 'link')

          @teams_hash    = { @home.id => @home, @away.id => @away }

          create_data(@teams_hash, data['team'], klass: Team, api: api, game: self) if data['team']
        end

        # def update_from_team(id, data)
        # end

        def home
          @teams_hash[@home_id] || @home
        end

        def away
          @teams_hash[@away_id] || @away
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
          drives.map(&:plays).compact
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
          create_data(@quarters_hash, data['quarters'], klass: Quarter, api: api, game: self) if data['quarters']
          check_newness(:pbp, plays.last&.description)
          check_newness(:score, @score)
          @pbp = @quarters_hash.values
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
          @quarter = data.delete('quarter').to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        end

      end
    end
  end
end

__END__

# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
# res = mlb.get_schedule;
# g = mlb.games.first
# g = Sportradar::Api::Baseball::Game.new('id' => "8cd71519-429f-4461-88a2-8a0e134eb89b")
g = Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184");
g = Sportradar::Api::Baseball::Game.new('id' => "fe9f37fd-6848-4a32-a999-9655044b7319");
res = g.get_pbp;
res = g.get_summary;
res = g.get_box # probably not as useful as summary


mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_daily_summary;
g = mlb.games[8];
g.count
g.get_pbp;
g.count

# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new;
# res = mlb.get_daily_summary;
# g = mlb.games.sort_by(&:scheduled).first;
g = Sportradar::Api::Baseball::Game.new('id' => "8731b56d-9037-44d1-b890-fa496e94dc10");
res = g.get_pbp;
res = g.get_summary;
g.pitchers

