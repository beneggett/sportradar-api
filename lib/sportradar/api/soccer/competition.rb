module Sportradar
  module Api
    module Soccer
      class Competition < Data
        attr_reader :id, :league_group, :name, :category, :coverage_info, :live_coverage, :season_coverage_info
        alias :display_name :name
        alias :alias :name

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"]
          @api          = opts[:api]

          @seasons_hash   = {}
          @teams_hash     = {}
          @standings_hash = {}
          @groups_hash    = {}

          update(data, **opts)
        end

        def update(data, **opts)
          # if data['tournament']
          #   update(data['tournament'])
          # end

          @name           = data["name"]          || @name
          @category       = data['category']      || @category
          @gender         = data['gender']        || @gender
          @coverage_info  = data['coverage_info'] || @coverage_info
          @live_coverage  = data.dig('coverage_info', 'live_coverage') || @live_coverage

          # parse_info(data)
          parse_season(data)
          # parse_results(data)
          # parse_standings(data)
        end

        def seasons
          @seasons_hash.values
        end

        def schedule
          return self if @schedule_retrieved
          get_schedule
          self
        end

        def year
          if current_season&.year&.split('/')&.last
            2000 + current_season.year.split('/').last.to_i
          end
        end

        def hierarchy
          self.get_seasons
          season = self.latest_season
          season.get_competitors
          season.competitors
        end

        def teams
          season = self.latest_season
          season.get_competitors if season.competitors.empty?
          season.competitors
        end

        def current_season
          seasons.detect(&:current?)
        end

        def latest_season
          seasons.max_by(&:end_date)
        end

        def standings(type = nil)
          if type
            @standings_hash[type]
          else
            @standings_hash.values
          end
        end

        def groups
          @groups_hash.values
        end

        def group(name = nil) # nil represents the complete team listing
          @groups_hash[name]
        end

        def matches
          @matches_hash.values
        end
        alias :games :matches

        # parsing helpers
        def parse_info(data)
          if data['groups']
            create_data(@groups_hash, data['groups'], klass: TeamGroup, api: api, competition: self, identifier: 'name')
          end
        end

        def parse_season(data)
          if data['season_coverage_info']
            @season_coverage_info = data['season_coverage_info'] if data['season_coverage_info']
            data['season_coverage_info']['id'] ||= data['season_coverage_info'].delete('season_id')
            create_data(@seasons_hash, data['season_coverage_info'], klass: Season, api: api, competition: self)
          end
          if data['current_season']
            create_data(@seasons_hash, data['current_season'], klass: Season, api: api, competition: self, current: true)
          end
          if data['seasons']
            create_data(@seasons_hash, data['seasons'], klass: Season, api: api, competition: self)
          end
        end

        def parse_results(data)
          if data['results']
            merged_data = Soccer.parse_results(data['results'])
            create_data(@matches_hash, merged_data, klass: Match, api: api, competition: self)
          end
        end

        def parse_standings(data)
          if data['standings']
            create_data(@standings_hash, data['standings'], klass: Standing, api: api, competition: self, identifier: 'type')
          end
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new
        end

        # url path helpers
        def path_base
          "competitions/#{ id }"
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

        def self.tournament_ids
          @tournament_ids ||= {
            # Europe group
            'eu.uefa_champions_league'  => "sr:tournament:7",
            'eu.la_liga'                => "sr:tournament:8",
            'eu.eng_premier_league'     => "sr:tournament:17",
            'eu.premier_league'         => "sr:tournament:17",
            'eu.serie_a'                => "sr:tournament:23",
            'eu.ligue_1'                => "sr:tournament:34",
            'eu.bundesliga'             => "sr:tournament:35",
            'eu.eredivisie'             => "sr:tournament:37",
            'eu.first_division_a'       => "sr:tournament:38",
            'eu.super_lig'              => "sr:tournament:52",
            'eu.super_league'           => "sr:tournament:185",
            'eu.rus_premier_league'     => "sr:tournament:203",
            'eu.ukr_premier_league'     => "sr:tournament:218",
            'eu.primeira_liga'          => "sr:tournament:238",
            'eu.uefa_super_cup'         => "sr:tournament:465",
            'eu.uefa_europa_league'     => "sr:tournament:679",
            'eu.uefa_youth_league'      => "sr:tournament:2324",
            # international (partial listing)
            "intl.world_cup"              => "sr:tournament:16",
            "intl.copa_america"           => "sr:tournament:133",
            "intl.gold_cup"               => "sr:tournament:140",
            "intl.africa_cup_of_nations"  => "sr:tournament:270",
            "intl.womens_world_cup"       => "sr:tournament:290",
            "intl.olympic_games"          => "sr:tournament:436",
            "intl.olympic_games_women"    => "sr:tournament:437",
            # other groups below
          }
        end

        self.tournament_ids.each do |tour_name, tour_id|
          group_code, name = tour_name.split('.')
          # define_singleton_method(name) { Sportradar::Api::Soccer::Tournament.new({'id' => tour_id}, league_group: group_code) }
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

group = Sportradar::Api::Soccer::Group.new(league_group: 'eu')
res = group.get_tournaments;
infos = group.tournaments.map{|tour| sleep 1; tour.get_info }
standings = group.tournaments.map{|tour| sleep 1; tour.get_standings }
results = group.tournaments.each{|tour| sleep 1; tour.get_results }.flat_map(&:matches)
standings = group.tournaments.map{|tour| sleep 1; (tour.get_standings rescue nil) }

{"UEFA Champions League"=>"sr:tournament:7",
 "LaLiga"=>"sr:tournament:8",
 "Premier League"=>"sr:tournament:218",
 "Serie A"=>"sr:tournament:23",
 "Ligue 1"=>"sr:tournament:34",
 "Bundesliga"=>"sr:tournament:35",
 "Eredivisie"=>"sr:tournament:37",
 "First Division A"=>"sr:tournament:38",
 "Super Lig"=>"sr:tournament:52",
 "Super League"=>"sr:tournament:185",
 "Primeira Liga"=>"sr:tournament:238",
 "UEFA Super Cup"=>"sr:tournament:465",
 "UEFA Europa League"=>"sr:tournament:679",
 "UEFA Youth League"=>"sr:tournament:2324"}

sample_leagues = [:la_liga, :eng_premier_league, :bundesliga, :serie_a, :ligue_1]
tours = sample_leagues.map { |code| Sportradar::Api::Soccer::Tournament.send(code) }
tours.each{|t| sleep 1; t.get_info }
teams = tours.flat_map(&:groups).flat_map(&:teams)
teams.each { |t| sleep 1; t.get_roster }


sample_leagues = [:la_liga, :eng_premier_league, :bundesliga, :serie_a, :ligue_1];
tours = sample_leagues.map { |code| Sportradar::Api::Soccer::Tournament.send(code) };
tours.each{|t| sleep 1; t.get_info };
tours.flat_map(&:groups).flat_map(&:teams);
teams = tours.flat_map(&:groups).flat_map(&:teams);
teams.each { |t| sleep 1; t.get_roster };
teams.map {|t| ["#{t.tournament_id} #{t.name}",t.jerseys]}.to_h
