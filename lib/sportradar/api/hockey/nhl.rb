module Sportradar
  module Api
    module Hockey
      class Nhl < Data
        attr_accessor :response, :id, :name, :alias, :season, :type
        def all_attributes
          [:name, :alias, :leagues, :divisions, :teams]
        end

        def initialize(data = {}, **opts)
          # @response = data
          @api    = opts[:api]
          @id     = data['id']
          @season = opts[:year]
          @type   = opts[:type]

          @conferences_hash = {}
          @games_hash = {}
          @teams_hash = {}

          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          # update stuff
          @id       = data.dig('league', 'id')    if data.dig('league', 'id')
          @name     = data.dig('league', 'name')  if data.dig('league', 'name')
          @alias    = data.dig('league', 'alias') if data.dig('league', 'alias')

          @season   = data.dig('season', 'year')  if data.dig('season', 'year')
          @type     = data.dig('season', 'type')  if data.dig('season', 'type')

          @conferences_hash = create_data({}, data['conferences'], klass: Conference, hierarchy: self, api: api) if data['conferences']
          @teams_hash       = create_data({}, data['teams'],   klass: Team,   hierarchy: self, api: api) if data['teams']
          @games_hash       = create_data({}, data['games'],   klass: Game,   hierarchy: self, api: api) if data['games']
        end

        def schedule(year = season_year)
          get_schedule(year) if games.empty?
          self
        end

        def standings(year = season_year)
          get_standings(year) if teams.first&.record.nil?
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

        def conferences
          @conferences_hash.values
        end
        def divisions
          conferences.flat_map(&:divisions)
        end
        def teams
          divisions.flat_map(&:teams)
        end
        # def teams
        #   teams = divisions.flat_map(&:teams)
        #   if teams.empty?
        #     if @teams_hash.empty?
        #       get_hierarchy
        #       divisions.flat_map(&:teams)
        #     else
        #       @teams_hash.values
        #     end
        #   else
        #     teams
        #   end
        # end
        def team(team_id)
          teams.detect { |team| team.id == team_id }
        end



        # api stuff
        def api
          @api || Sportradar::Api::Hockey::Nhl::Api.new
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
          @season || default_year
        end
        def nhl_season
          @type || default_season
        end


        # url paths
        def path_base
          "league"
        end
        def path_schedule(year = season_year)
          "games/#{year}/#{nhl_season}/schedule"
        end
        def path_series
          "series/#{season_year}/#{nhl_season}/schedule"
        end
        def path_rankings
          "seasontd/#{season_year}/#{nhl_season}/rankings"
        end
        def path_hierarchy
          "#{ path_base }/hierarchy"
        end
        def path_depth_charts
          "#{ path_base }/depth_charts"
        end
        def path_standings(year = season_year)
          "seasontd/#{year}/#{nhl_season}/standings"
        end
        def path_daily_summary(date)
          "games/#{date.year}/#{date.month}/#{date.day}/summary"
        end
        def path_daily_boxscore(date)
          "#{ path_base }/games/#{date.year}/#{date.month}/#{date.day}/boxscore"
        end


        # data retrieval

        ## schedule
        def get_schedule(year = season_year)
          data = api.get_data(path_schedule(year)).to_h
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
        def get_standings(year = season_year)
          data = api.get_data(path_standings(year)).to_h
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

nhl = Sportradar::Api::Hockey::Nhl.new
res = nhl.get_hierarchy;
t = nhl.teams.sample;
t.get_season_stats(2016);
t.players.sample

res = nhl.get_schedule(2016);
# g = nhl.games.sort_by(&:scheduled).first

Sportradar::Api::Hockey::Nhl.new
