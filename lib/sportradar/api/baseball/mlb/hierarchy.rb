module Sportradar
  module Api
    module Baseball
      class Mlb
        class Hierarchy < Data
          attr_accessor :response, :id, :name, :alias
          def all_attributes
            [:name, :alias, :leagues, :divisions, :teams]
          end

          def initialize(data = {}, **opts)
            # @response = data
            @api  = opts[:api]
            @id   = data.dig('league', 'id')

            @leagues_hash = {}
            @games_hash = {}

          end

          def update(data, source: nil, **opts)
            # update stuff
            @name     = data.dig('league', 'name')  if data.dig('league', 'name')
            @alias    = data.dig('league', 'alias') if data.dig('league', 'alias')

            @year     = data.dig('season', 'year')  if data.dig('season', 'year')
            @type     = data.dig('season', 'type')  if data.dig('season', 'type')

            @leagues_hash = create_data({}, data['leagues'], klass: League, hierarchy: self, api: api) if data['leagues']
            @games_hash   = create_data({}, data['games'],   klass: Game,   hierarchy: self, api: api) if data['games']
          end

          def games
            @games_hash.values
          end

          def leagues
            @leagues_hash.values
          end
          def divisions
            leagues.flat_map(&:divisions)
          end
          def teams
            teams = divisions.flat_map(&:teams)
            if teams.empty?
              get_hierarchy
              divisions.flat_map(&:teams)
            else
              teams
            end
          end
          def team(team_id)
            teams.detect { |team| team.id == team_id }
          end

          # api stuff
          def api
            @api || Sportradar::Api::Baseball::Mlb.new
          end

          def default_year
            Date.today.year - 1 # FIXME - DEVELOPMENT ONLY
          end
          def default_date
            Date.today
          end
          def default_season
            'reg'
          end
          def season_year
            @year || default_year
          end
          def mlb_season
            @type || default_season
          end

          # url paths
          def path_base
            "league"
          end
          def path_schedule
            "games/#{season_year}/#{mlb_season}/schedule"
          end
          def path_series
            "series/#{season_year}/#{mlb_season}/schedule"
          end
          def path_rankings
            "seasontd/#{season_year}/#{mlb_season}/rankings"
          end
          def path_hierarchy
            "#{ path_base }/hierarchy"
          end
          def path_depth_charts
            "#{ path_base }/depth_charts"
          end
          def path_standings
            "season_td/#{season_year}/#{mlb_season}/standings"
          end
          def path_daily_summary(date)
            "#{ path_base }/games/#{date.year}/#{date.month}/#{date.day}/summary"
          end
          def path_daily_boxscore(date)
            "#{ path_base }/games/#{date.year}/#{date.month}/#{date.day}/boxscore"
          end

          # data retrieval

          ## schedule
          def get_schedule
            data = api.get_data(path_schedule).to_h
            ingest_schedule(data)
          end

          def ingest_schedule(data)
            update(data, source: :games)
            data
          end

          def queue_schedule
            url, headers, options, timeout = api.get_request_info(path_schedule)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
          end

          ## hierarchy
          def get_hierarchy
            data = api.get_data(path_hierarchy).to_h
            ingest_hierarchy(data)
          end

          def ingest_hierarchy(data)
            update(data, source: :teams)
            data
          end

          def queue_hierarchy
            url, headers, options, timeout = api.get_request_info(path_hierarchy)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_hierarchy)}
          end

          ## depth_charts
          def get_depth_charts
            data = api.get_data(path_depth_charts).to_h
            ingest_depth_charts(data)
          end

          def ingest_depth_charts(data)
            update(data, source: :teams)
            data
          end

          def queue_depth_charts
            url, headers, options, timeout = api.get_request_info(path_depth_charts)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_depth_charts)}
          end

          ## standings
          def get_standings
            data = api.get_data(path_standings).to_h
            ingest_standings(data)
          end

          def ingest_standings(data)
            update(data, source: :teams)
            data
          end

          def queue_standings
            url, headers, options, timeout = api.get_request_info(path_standings)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_standings)}
          end

          ## daily summary
          def get_daily_summary(date = Date.today)
            data = api.get_data(path_daily_summary(date)).to_h
            ingest_daily_summary(data)
          end

          def ingest_daily_summary(data)
            update(data, source: :games)
            data
          end

          def queue_daily_summary(date = Date.today)
            url, headers, options, timeout = api.get_request_info(path_daily_summary(date))
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_daily_summary)}
          end

          ## venues
          def get_venues
            data = api.get_data(path_venues).to_h
            ingest_venues(data)
          end

          def ingest_venues(data)
            update(data, source: :teams)
            data
          end

          def queue_venues
            url, headers, options, timeout = api.get_request_info(path_venues)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_venues)}
          end

        end
      end
    end
  end
end

__END__

mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_hierarchy;
t = mlb.teams.first;
t.get_season_stats(2016);
t.players.sample

res = mlb.get_schedule;
g = mlb.games.first


