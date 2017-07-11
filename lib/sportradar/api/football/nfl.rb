module Sportradar
  module Api
    module Football
      class Nfl < Data
        attr_accessor :response, :id, :name, :alias, :type
        def all_attributes
          [:name, :alias, :leagues, :divisions, :teams]
        end

        def initialize(data = {}, **opts)
          # @response = data
          @api  = opts[:api]
          @id   = data['id']
          @season = opts[:year]
          @type   = opts[:type]

          @conferences_hash = {}
          @weeks_hash = {}
          @games_hash = {}
          @teams_hash = {}

        end

        def update(data, source: nil, **opts)
          # update stuff
          @id     = data['id'] if data['id']
          if data['season'].is_a?(Hash)
            @season = data.dig('season', 'year')  if data.dig('season', 'year')
            @type   = data.dig('season', 'type')  if data.dig('season', 'type')
          else
            @season = data['season']  if data['season']
            @type   = data['type']    if data['type']
          end
          # @name     = data.dig('league', 'name')  if data.dig('league', 'name')
          # @alias    = data.dig('league', 'alias') if data.dig('league', 'alias')

          # @year     = data.dig('season', 'year')  if data.dig('season', 'year')
          # @type     = data.dig('season', 'type')  if data.dig('season', 'type')

          create_data(@conferences_hash,  data['conferences'],  klass: Conference,  hierarchy: self, api: api) if data['conferences']
          create_data(@teams_hash,        data['teams'],        klass: Team,        hierarchy: self, api: api) if data['teams']

          if data['weeks']
            create_data(@weeks_hash, data['weeks'], klass: Week, hierarchy: self, api: @api)
          end
          if data['league']
            @id    = data['id']
            @name  = data['name']
            @alias = data['alias']
          end

          if data['games']
            if data['games'].first.keys == ['game']
              data['games'].map! { |hash| hash['game'] }
            end
            @games_hash = create_data(@games_hash, data['games'],   klass: Game,   hierarchy: self, api: api)
          end

          self
        end
        def weeks
          @weeks_hash.values
        end
        def conferences
          @conferences_hash.values
        end
        # def conference(code_name)
        #   conferences_by_name[code_name]
        # end
        # private def conferences_by_name
        #   @conferences_by_name ||= conferences.map { |d| [d.alias, d] }.to_h
        # end
        def divisions
          conferences.flat_map(&:divisions)
        end
        def teams
          divisions.flat_map(&:teams)
        end

        def schedule
          get_schedule if games.empty?
          self
        end

        def standings
          get_standings if divisions.empty? || teams.first&.record.nil?
          self
        end

        def hierarchy
          get_hierarchy if divisions.empty?
          self
        end

        def games
          get_schedule if @weeks_hash.empty?
          weeks.flat_map(&:games)
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
          @api || Sportradar::Api::Football::Nfl::Api.new
        end

        def default_year
          (Date.today - 60).year
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
        alias :year :season_year
        def nfl_season
          @type || default_season
        end
        alias :season :nfl_season


        # url paths
        def path_base
          "league"
        end
        def path_hierarchy
          "league/hierarchy"
        end
        def path_schedule
          "games/#{season_year}/#{nfl_season}/schedule"
        end
        def path_weekly_schedule(nfl_season_week)
          "games/#{season_year}/#{nfl_season}/#{nfl_season_week}/schedule"
        end
        # def path_rankings(nfl_season_week, poll_name = 'AP25')
        #   "polls/#{poll_name}/#{season_year}/#{nfl_season_week}/rankings"
        # end
        def path_standings
          "seasontd/#{season_year}/standings"
        end

        # data retrieval

        ## schedule
        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end

        def ingest_schedule(data)
          update(data, source: :weeks)
          data
        end

        def queue_schedule
          url, headers, options, timeout = api.get_request_info(path_schedule)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
        end

        ## weekly schedule
        def get_weekly_schedule(nfl_season_week = 1)
          data = api.get_data(path_weekly_schedule(nfl_season_week)).to_h
          ingest_weekly_schedule(data)
        end

        def ingest_weekly_schedule(data)
          # update(data, source: :weeks)
          create_data(@weeks_hash, data['week'], klass: Week, hierarchy: self, api: api)
          data
        end

        def queue_weekly_schedule(nfl_season_week = 1)
          url, headers, options, timeout = api.get_request_info(path_weekly_schedule(nfl_season_week))
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_weekly_schedule)}
        end

        ## hierarchy
        def get_hierarchy
          data = api.get_data(path_hierarchy).to_h
          ingest_hierarchy(data)
        end

        def ingest_hierarchy(data)
          # create_data(@divisions_hash, data, klass: Division,  hierarchy: self, api: api)
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

        ## statistics

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

        def self.sim_api
          Sportradar::Api::Football::Nfl::Api.new('sim')
        end
        def self.simulation
          new({}, api: sim_api, year: 2015, type: 'reg')
        end
        def self.simulations
          api = sim_api
          ['f45b4a31-b009-4039-8394-42efbc6d5532', '5a7042cb-fe7a-4838-b93f-6b8c167ec384', '7f761bb5-7963-43ea-a01b-baf4f5d50fe3'].map do |game_id|
            Game.new({'id' => game_id}, api: api)
          end
        end

      end
    end
  end
end

__END__



nfl = Sportradar::Api::Football::Nfl.new
nfl = Sportradar::Api::Football::Nfl.new(year: 2016)
res1 = nfl.get_schedule;
res1 = nfl.get_hierarchy;
res1 = nfl.get_standings;
res2 = nfl.get_weekly_schedule;

nfl = Marshal.load(File.binread('nfl.bin'));
File.binwrite('nfl.bin', Marshal.dump(nfl))

