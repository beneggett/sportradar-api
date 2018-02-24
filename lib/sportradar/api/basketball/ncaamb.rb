module Sportradar
  module Api
    module Basketball
      class Ncaamb < Data
        attr_accessor :response, :id, :name, :alias
        def all_attributes
          [:name, :alias, :conferences, :divisions, :teams]
        end

        def initialize(data = {}, **opts)
          @response = data
          @api      = opts[:api]
          @id       = data['id']
          @season   = opts[:year]
          @type     = opts[:type]

          @divisions_hash     = create_data({}, {"id" => "c5a8d640-5093-4044-851d-2c562e929994", "name" => "NCAA Division I", "alias" => "D1"}, klass: Division, api: api)
          @weeks_hash         = {}
          @games_hash         = {}
          @tournaments_hash   = {}
          @teams_hash         = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @id     = data['id'] if data['id']

          if data['league']
            @id    = data.dig('league', 'id')
            @name  = data.dig('league', 'name')
            @alias = data.dig('league', 'alias')
          end

          if data['season'].is_a?(Hash)
            @season   = data.dig('season', 'year')
            @type     = data.dig('season', 'type')
          else
            @season = data['season']  if data['season']
            @type   = data['type']    if data['type']
          end

          create_data(@teams_hash,        data['teams'],        klass: Team,        api: api) if data['teams']
          create_data(@divisions_hash,    data['divisions'],    klass: Division,    api: api) if data['divisions']
          create_data(@games_hash,        data['games'],        klass: Game,        api: api) if data['games']
          create_data(@tournaments_hash,  data['tournaments'],  klass: Tournament,  api: api) if data['tournaments']
        end

        def divisions
          @divisions_hash.values
        end
        def division(code_name)
          divisions_by_name[code_name]
        end
        private def divisions_by_name
          @divisions_by_name ||= divisions.map { |d| [d.alias, d] }.to_h
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

        def tournaments
          get_tournaments if @tournaments_hash.empty?
          @tournaments_hash.values
        end

        def games
          @games_hash.values
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

        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end
        def ingest_schedule(data)
          update(data)
          data
        end

        def get_tournaments(tourney_season = 'pst')
          data = api.get_data(path_tournaments(tourney_season)).to_h
          ingest_tournaments(data)
        end
        def ingest_tournaments(data)
          update(data)
          data
        end

        def get_conference_tournaments
          data = api.get_data(path_conference_tournaments).to_h
          ingest_conference_tournaments(data)
        end
        def ingest_conference_tournaments(data)
          update(data)
          data
        end

        def get_daily_schedule(date = default_date)
          data = api.get_data(path_daily_schedule(date)).to_h
          ingest_daily_schedule(data)
        end
        def ingest_daily_schedule(data)
          update(data)
          data
        end

        def get_rankings(poll_name, ncaamb_week = nil)
          data = api.get_data(path_rankings(poll_name, ncaamb_week)).to_h
          ingest_rankings(data)
        end
        def ingest_rankings(data)
          update(data)
          data
        end

        def get_hierarchy
          data = api.get_data(path_hierarchy).to_h
          ingest_hierarchy(data)
        end
        def ingest_hierarchy(data)
          update(data)
          data
        end

        def get_standings
          data = api.get_data(path_standings).to_h
          ingest_standings(data)
        end
        def ingest_standings(data)
          division('D1').update(data)
          data
        end

        def api
          @api || Sportradar::Api::Basketball::Ncaamb::Api.new
        end

        def default_year
          (Date.today - 210).year
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
        def ncaamb_season
          @type || default_season
        end
        alias :season :ncaamb_season

        def path_schedule
          "games/#{season_year}/#{ncaamb_season}/schedule"
        end

        def path_tournaments(tourney_season = 'pst')
          "tournaments/#{season_year}/#{tourney_season}/schedule"
        end

        def path_conference_tournaments
          path_tournaments('ct')
        end

        def path_daily_schedule(date = default_date)
          "games/#{ date.year }/#{ date.month }/#{ date.day }/schedule"
        end

        def path_rankings(poll_name, ncaamb_week = nil, season_year = default_year)
          "polls/#{poll_name}/#{season_year}/#{ncaamb_week}/rankings"
        end

        def path_hierarchy
          "league/hierarchy"
        end

        def path_standings
          "seasontd/#{season_year}/#{ncaamb_season}/standings"
        end

      end
    end
  end
end

__END__

sr = Sportradar::Api::Basketball::Ncaamb.new
ss = sr.schedule(2015, 'ct');
ss = sr.schedule(2015, 'pst');
rank = sr.rankings('US');
ds = sr.daily_schedule;

# not ready
lh = sr.league_hierarchy;
ls = sr.standings;