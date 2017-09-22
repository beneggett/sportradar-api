module Sportradar
  module Api
    module Football
      class Ncaafb < Data
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

          @divisions_hash = {}
          @weeks_hash = {}
          @games_hash = {}
          @teams_hash = {}

        end

        def update(data, source: nil, **opts)
          # update stuff
          @id     = data['id'] if data['id']
          @season = data['season']  if data['season']
          @type   = data['type']    if data['type']
          # @name     = data.dig('league', 'name')  if data.dig('league', 'name')
          # @alias    = data.dig('league', 'alias') if data.dig('league', 'alias')

          # @year     = data.dig('season', 'year')  if data.dig('season', 'year')
          # @type     = data.dig('season', 'type')  if data.dig('season', 'type')

          create_data(@divisions_hash, data['divisions'], klass: Division,  hierarchy: self, api: api) if data['divisions']
          create_data(@divisions_hash, data['division'], klass: Division,  hierarchy: self, api: api) if data['division']
          create_data(@teams_hash,     data['teams'],     klass: Team,      hierarchy: self, api: api) if data['teams']

          if data['weeks']
            create_data(@weeks_hash, data['weeks'], klass: Week, hierarchy: self, api: @api)
          end

          if data['games']
            if data['games'].first.keys == ['game']
              data['games'].map! { |hash| hash['game'] }
            end
            @games_hash = create_data(@games_hash, data['games'],   klass: Game,   hierarchy: self, api: api)
          end
        end
        def weeks
          @weeks_hash.values
        end
        def divisions
          @divisions_hash.values
        end
        def division(code_name)
          divisions_by_name[code_name]
        end
        private def divisions_by_name
          @divisions_by_name ||= divisions.map { |d| [d.id, d] }.to_h
        end
        def conferences
          divisions.flat_map(&:conferences)
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
          teams = conferences.flat_map(&:teams)
          if teams.empty?
            if @teams_hash.empty?
              get_hierarchy
              conferences.flat_map(&:teams)
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
          @api || Sportradar::Api::Football::Ncaafb::Api.new
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
        def ncaafb_season
          @type || default_season
        end
        alias :season :ncaafb_season


        # url paths
        def path_base
          "league"
        end
        def path_hierarchy(division = 'FBS')
          "teams/#{division}/hierarchy"
        end
        def path_schedule
          "#{season_year}/#{ncaafb_season}/schedule"
        end
        def path_weekly_schedule(ncaafb_season_week)
          "#{season_year}/#{ncaafb_season}/#{ncaafb_season_week}/schedule"
        end
        def path_rankings(ncaafb_season_week, poll_name = 'AP25')
          "polls/#{poll_name}/#{season_year}/#{ncaafb_season_week}/rankings"
        end
        def path_standings(division = 'FBS')
          "teams/#{division}/#{season_year}/#{ncaafb_season}/standings"
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
        def get_weekly_schedule(ncaafb_season_week = 1)
          data = api.get_data(path_weekly_schedule(ncaafb_season_week)).to_h
          ingest_weekly_schedule(data)
        end

        def ingest_weekly_schedule(data)
          # update(data, source: :weeks)
          create_data(@weeks_hash, data, klass: Week, hierarchy: self, api: api)
          data
        end

        def queue_weekly_schedule(ncaafb_season_week = 1)
          url, headers, options, timeout = api.get_request_info(path_weekly_schedule(ncaafb_season_week))
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_weekly_schedule)}
        end

        ## hierarchy
        def get_hierarchy(division = 'FBS')
          data = api.get_data(path_hierarchy(division)).to_h
          ingest_hierarchy(data)
        end

        def ingest_hierarchy(data)
          create_data(@divisions_hash, data, klass: Division,  hierarchy: self, api: api)
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
        def get_standings(division = 'FBS')
          data = api.get_data(path_standings(division)).to_h
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
          Sportradar::Api::Football::Ncaafb::Api.new.sim!
        end
        def self.simulation
          new({}, api: sim_api, year: 2015, type: 'reg')
        end
        def self.simulations
          api = sim_api
          ['2015/REG/1/WKY/MSH', '2015/REG/1/KEN/FLA', '2015/REG/1/WOU/PRST'].map do |game_uri|
            Game.new({'id' => game_uri}).sim!
          end
        end

      end
    end
  end
end

__END__



ncaafb = Sportradar::Api::Football::Ncaafb.new
ncaafb = Sportradar::Api::Football::Ncaafb.new(year: 2016)
gg = ncaafb.games;
tt = ncaafb.teams;
File.binwrite('ncaafb.bin', Marshal.dump(ncaafb))
ncaafb = Marshal.load(File.binread('ncaafb.bin'));
