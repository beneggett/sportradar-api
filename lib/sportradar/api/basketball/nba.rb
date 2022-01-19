module Sportradar
  module Api
    module Basketball
      class Nba < Data
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

          @conferences_hash   = {}
          @weeks_hash         = {}
          @games_hash         = {}
          @series_hash        = {}
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
          create_data(@conferences_hash,  data['conferences'],  klass: Conference,  api: api) if data['conferences']
          create_data(@games_hash,        data['games'],        klass: Game,        api: api) if data['games']
          create_data(@series_hash,       data['series'],       klass: Series,      api: api) if data['series']
        end

        def conferences
          @conferences_hash.values
        end
        def divisions
          conferences.flat_map(&:divisions)
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

        def series_schedule
          get_series_schedule if series.empty?
          self
        end

        def games
          @games_hash.values
        end

        def series
          @series_hash.values
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

        def api
          @api ||= Sportradar::Api::Basketball::Nba::Api.new
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
        def nba_season
          @type || default_season
        end
        alias :season :nba_season

        def path_schedule
          "games/#{season_year}/#{nba_season}/schedule"
        end

        def path_daily_schedule(date = default_date)
          "games/#{ date.year }/#{ date.month }/#{ date.day }/schedule"
        end

        def path_series_schedule
          "series/#{season_year}/pst/schedule"
        end

        def path_hierarchy
          "league/hierarchy"
        end

        def path_standings
          "seasontd/#{season_year}/#{nba_season}/standings"
        end

        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end
        def ingest_schedule(data)
          update(data, source: :schedule)
          data
        end

        def get_daily_schedule(date = default_date)
          data = api.get_data(path_daily_schedule(date)).to_h
          ingest_daily_schedule(data)
        end
        def ingest_daily_schedule(data)
          update(data, source: :daily_schedule)
          data
        end

        def get_series_schedule
          data = api.get_data(path_series_schedule).to_h
          ingest_series_schedule(data)
        end
        def ingest_series_schedule(data)
          update(data, source: :series_schedule)
          data
        end

        def get_hierarchy
          data = api.get_data(path_hierarchy).to_h
          ingest_hierarchy(data)
        end
        def ingest_hierarchy(data)
          update(data, source: :hierarchy)
          data
        end

        def get_standings
          data = api.get_data(path_standings).to_h
          ingest_standings(data)
        end
        def ingest_standings(data)
          update(data, source: :standings)
          data
        end

      end
    end
  end
end

__END__

st = sr.standings;
sc = sr.schedule;
sr = Sportradar::Api::Basketball::Nba.new
lh = sr.hierarchy;
t = lh.teams.first;
t.venue.id
