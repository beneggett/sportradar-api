module Sportradar
  module Api
    module Hockey
      class Game < Data
        attr_reader :response, :id, :title, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          # @season   = opts[:season]
          @updates  = {}
          @changes  = {}

          @score          = {}
          @team_stats     = {}
          @player_stats   = {}
          @teams_hash     = {}
          # @scoring_raw    = Scoring.new(data, game: self)
          # @periods_hash   = {}
          # @goalies        = {}

          @id = data['id']

          update(data, **opts)
        end

        def timeouts
          {}
        end

        def tied?
          @score[away_id].to_i == @score[home_id].to_i
        end

        # def summary_stat(team_id, stat_name)
        #   scoring.dig(team_id, stat_name)
        # end
        # def stats(team_id)
        #   team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]].to_i : @team_stats[team_id].to_i
        # end

        def scoring
          @scoring_raw.scores
        end
        def update_score(score)
          @score.merge!(score)
        end
        # def update_stats(team, stats)
        #   @team_stats.merge!(team.id => stats.merge!(team: team))
        # end
        # def update_player_stats(player, stats)
        #   @player_stats.merge!(player.id => stats.merge!(player: player))
        # end

        def parse_score(data)
        end

        def parse_goalies(data)
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

          @final        = data['final']                 if data['final']

          @team_ids     = { home: @home_id, away: @away_id}

          parse_goalies(data) if data['home'] && data['away']

          # if data['scoring']
          #   parse_score(data['scoring'])
          # elsif data.dig('home', 'hits')
          #   parse_score(data)
          # end
          # @scoring_raw.update(data, source: source)
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
          if !future? && periods.empty?
            get_pbp
          end
          @pbp ||= periods
        end


        def summary
          @summary ||= get_summary
        end

        def periods
          @periods_hash.values
        end
        def half_periods
          periods.flat_map(&:half_periods)
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
          create_data(@periods_hash, data['periods'], klass: Inning, api: api, game: self) if data['periods']
          extract_count(data)
          check_newness(:events, events.last&.description)
          check_newness(:score, @score)
          @pbp = @periods_hash.values
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
          @period = data.delete('period').to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        end

        def set_pbp(data)
          create_data(@periods_hash, data, klass: Period, api: api, game: self)
          @periods_hash
        end

        def api
          @api || Sportradar::Api::Hockey::NhlApi.new
        end
      end
    end
  end
end

__END__

# nhl = Sportradar::Api::Hockey::Nhl.new
# res = nhl.get_schedule;
# g = nhl.games.first
# g = Sportradar::Api::Hockey::Game.new('id' => "")
g = Sportradar::Api::Hockey::Game.new('id' => "");
g = Sportradar::Api::Hockey::Game.new('id' => "");
res = g.get_pbp;
res = g.get_summary;
res = g.get_box # probably not as useful as summary


nhl = Sportradar::Api::Hockey::Nhl.new
res = nhl.get_daily_summary;
g = nhl.games[8];
g.count
g.get_pbp;
g.count

# nhl = Sportradar::Api::Hockey::Nhl.new;
# res = nhl.get_daily_summary;
# g = nhl.games.sort_by(&:scheduled).first;
g = Sportradar::Api::Hockey::Game.new('id' => "");
res = g.get_pbp;
res = g.get_summary;
g.goalies

