module Sportradar
  module Api
    module Baseball
      class Mlb < Data
        attr_accessor :response, :id, :name, :alias, :year, :type
        def all_attributes
          [:name, :alias, :leagues, :divisions, :teams]
        end

        def initialize(data = {}, **opts)
          # @response = data
          @api      = opts[:api]
          @id       = data['id']
          @season   = opts[:year]
          @type     = opts[:type]

          @leagues_hash = {}
          @games_hash = {}
          @teams_hash = {}

          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          # update stuff
          @id       = data.dig('league', 'id')    if data.dig('league', 'id')
          @name     = data.dig('league', 'name')  if data.dig('league', 'name')
          @alias    = data.dig('league', 'alias') if data.dig('league', 'alias')

          @year     = data.dig('season', 'year')  if data.dig('season', 'year')
          @type     = data.dig('season', 'type')  if data.dig('season', 'type')

          @leagues_hash = create_data({}, data['leagues'], klass: League, hierarchy: self, api: api) if data['leagues']
          @teams_hash   = create_data({}, data['teams'],   klass: Team,   hierarchy: self, api: api) if data['teams']
          if data['games'] && !data['games'].empty?
            if data['games'].first.keys == ['game']
              data['games'].map! { |hash| hash['game'] }
            end
            @games_hash = create_data({}, data['games'],   klass: Game,   hierarchy: self, api: api)
          end
        end

        def schedule
          get_schedule if games.empty?
          self
        end

        def standings
          get_standings if teams.first&.record.nil?
          self
        end

        def hierarchy
          get_hierarchy if divisions.empty?
          self
        end

        def daily_schedule
          # TODO
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
            if @teams_hash.empty?
              get_hierarchy
              divisions.flat_map(&:teams)
            else
              @teams_hash.values
            end
          else
            teams
          end
        end
        def team(team_id)
          teams.detect { |team| team.id == team_id }
        end



        # api stuff
        def api
          @api ||= Sportradar::Api::Baseball::Mlb::Api.new
        end

        def default_year
          Date.today.year
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
          "seasontd/#{season_year}/#{mlb_season}/standings"
        end
        def path_daily_summary(date)
          "games/#{date.year}/#{date.month}/#{date.day}/summary"
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
          update(data.dig('league','season'), source: :teams)
          data
        end

        def queue_standings
          url, headers, options, timeout = api.get_request_info(path_standings)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_standings)}
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

        ## daily summary
        def get_daily_summary(date = Date.today)
          data = api.get_data(path_daily_summary(date)).to_h
          ingest_daily_summary(data)
        end

        def ingest_daily_summary(data)
          update(data.dig('league'), source: :games)
          data
        end

        def queue_daily_summary(date = Date.today)
          url, headers, options, timeout = api.get_request_info(path_daily_summary(date))
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_daily_summary)}
        end

        ## venues
        # def get_venues
        #   data = api.get_data(path_venues).to_h
        #   ingest_venues(data)
        # end

        # def ingest_venues(data)
        #   update(data, source: :teams)
        #   data
        # end

        # def queue_venues
        #   url, headers, options, timeout = api.get_request_info(path_venues)
        #   {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_venues)}
        # end

      end
    end
  end
end

__END__

mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_daily_summary;
res = mlb.get_hierarchy;
res = mlb.get_schedule;
t = mlb.teams.first;
t.get_season_stats;
t.players.sample

res = mlb.get_schedule;
g = mlb.games.sort_by(&:scheduled).first

portradar::Api::Baseball::Mlb::Hierarchy.new
