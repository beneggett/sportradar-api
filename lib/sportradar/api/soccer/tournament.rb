module Sportradar
  module Api
    module Soccer
      class Tournament < Data
        attr_reader :id, :league_group, :name, :category

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"]
          @api          = opts[:api]
          @name         = data["name"]
          @league_group = league_group || data['league_group'] || @api&.league_group

          @matches_hash   = {}
          @seasons_hash   = {}
          @teams_hash     = {}
          @standings_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          if data['tournament']
            update(data['tournament'])
          end

          @category = data['category'] || @category

          parse_season(data)
          parse_results(data)
          parse_schedule(data)
          parse_standings(data)
        end

        def seasons
          @seasons_hash.values
        end

        def standings(type = nil)
          if type
            @standings_hash[type]
          else
            @standings_hash.values
          end
        end

        def matches
          @matches_hash.values
        end
        alias :games :matches

        # parsing helpers
        def parse_season(data)
          if data['season_coverage_info']
            data['season_coverage_info']['id'] ||= data['season_coverage_info'].delete('season_id')
            create_data(@seasons_hash, data['season_coverage_info'], klass: Season, api: api)
          end
          if data['current_season']
            create_data(@seasons_hash, data['current_season'], klass: Season, api: api, current: true)
          end
          if data['seasons']
            create_data(@seasons_hash, data['seasons'], klass: Season, api: api)
          end
        end

        def parse_results(data)
          if data['results']
            merged_data = Soccer.parse_results(data['results'])
            create_data(@matches_hash, merged_data, klass: Match, api: api)
          end
        end

        def parse_schedule(data)
          if data['sport_events']
            create_data(@matches_hash, data['sport_events'], klass: Match, api: api)
          end
        end

        def parse_standings(data)
          if data['standings']
            create_data(@standings_hash, data['standings'], klass: Standing, api: api, identifier: 'type')
          end
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        # url path helpers
        def path_base
          "tournaments/#{ id }"
        end

        def path_live_standings
          "#{ path_base }/live_standings"
        end
        def get_live_standings
          data = api.get_data(path_live_standings).to_h
          ingest_live_standings(data)
        end
        alias :get_standings :get_live_standings
        def ingest_live_standings(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "season", "standings"]
          data
        end
        def queue_live_standings
          url, headers, options, timeout = api.get_request_info(path_live_standings)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_live_standings)}
        end

        def path_results
          "#{ path_base }/results"
        end
        def get_results
          data = api.get_data(path_results).to_h
          ingest_results(data)
        end
        def ingest_results(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "results"]
          data
        end
        def queue_results
          url, headers, options, timeout = api.get_request_info(path_results)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_results)}
        end

        def path_schedule
          "#{ path_base }/schedule"
        end
        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end
        def ingest_schedule(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "sport_events"]
          data
        end
        def queue_schedule
          url, headers, options, timeout = api.get_request_info(path_schedule)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
        end

        def path_seasons
          "#{ path_base }/seasons"
        end
        def get_seasons
          data = api.get_data(path_seasons).to_h
          ingest_seasons(data)
        end
        def ingest_seasons(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "seasons"]
          data
        end
        def queue_seasons
          url, headers, options, timeout = api.get_request_info(path_seasons)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_seasons)}
        end

        def path_info
          "#{ path_base }/info"
        end
        def get_info
          data = api.get_data(path_info).to_h
          ingest_info(data)
        end
        def ingest_info(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "season", "round", "season_coverage_info", "coverage_info", "groups"]
          data
        end
        def queue_info
          url, headers, options, timeout = api.get_request_info(path_info)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_info)}
        end

        def path_leaders
          "#{ path_base }/leaders"
        end
        def get_leaders
          data = api.get_data(path_leaders).to_h
          ingest_leaders(data)
        end
        def ingest_leaders(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "season_coverage_info", "top_points", "top_goals", "top_assists", "top_cards", "top_own_goals"]
          data
        end
        def queue_leaders
          url, headers, options, timeout = api.get_request_leaders(path_leaders)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_leaders)}
        end

      end
    end
  end
end

__END__

{"id"=>"sr:tournament:17",
    "name"=>"Premier League",
    "sport"=>{"id"=>"sr:sport:1", "name"=>"Soccer"},
    "category"=>{"id"=>"sr:category:1", "name"=>"England", "country_code"=>"ENG"},
    "current_season"=>{"id"=>"sr:season:40942", "name"=>"Premier League 17/18", "start_date"=>"2017-08-11", "end_date"=>"2018-05-14", "year"=>"17/18"},
    "season_coverage_info"=>{"season_id"=>"sr:season:40942", "scheduled"=>381, "played"=>70, "max_coverage_level"=>"platinum", "max_covered"=>70, "min_coverage_level"=>"platinum"}}


group = Sportradar::Api::Soccer::Group.new(league_group: 'eu')
res = group.get_tournaments;
tour = group.tournaments.sample
tour.get_seasons
tour.get_results
res = tour.get_schedule
tour.matches.size
tour

