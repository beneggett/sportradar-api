module Sportradar
  module Api
    module Soccer
      class Season < Data
        attr_reader :id, :league_group, :name, :category, :current_season, :season_coverage_info, :competition, :start_date, :end_date

        def initialize(data = {}, competition: nil, **opts)
          @response     = data
          @id           = data["id"]
          @api          = opts[:api]
          @competition  = competition
          @matches_hash = {}
          @competitors_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @league_group       = opts[:league_group] || data['league_group'] || @league_group
          @id                 = data['id'] || data['season_id'] || @id
          @current            = opts[:current] || @current
          # get_tournament_id(data, **opts)

          @name               = data['name']                || @name
          @start_date         = data['start_date']          || @start_date
          @end_date           = data['end_date']            || @end_date
          @year               = data['year']                || @year
          @scheduled          = data['scheduled']           || @scheduled
          @played             = data['played']              || @played
          @max_coverage_level = data['max_coverage_level']  || @max_coverage_level
          @max_covered        = data['max_covered']         || @max_covered
          @min_coverage_level = data['min_coverage_level']  || @min_coverage_level

          parse_schedule(data)
          parse_competitors(data)
        end

        # def get_tournament_id(data, **opts)
        #   @tournament_id ||= if opts[:tournament]
        #     opts[:tournament].id
        #   elsif data['tournament_id']
        #     data['tournament_id']
        #   elsif data['tournament']
        #     data.dig('tournament', 'id')
        #   end
        # end

        def current?
          !!@current
        end

        def matches
          @matches_hash.values
        end

        def competitors
          @competitors_hash.values
        end

        def parse_schedule(data)
          if data['schedules']
            create_data(@matches_hash, data['schedules'], klass: Match, api: api, competition: @competition, season: self)
          end
        end

        def parse_competitors(data)
          if data['season_competitors']
            create_data(@competitors_hash, data['season_competitors'], klass: Team, api: api, competition: @competition, season: self)
          end
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def path_base
          "seasons/#{@id}"
        end

        def path_schedule
          "#{ path_base }/schedules"
        end
        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end
        def ingest_schedule(data)
          @schedule_retrieved = true
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "sport_events"]
          data
        end

        def path_competitors
          "#{ path_base }/competitors"
        end
        def get_competitors
          data = api.get_data(path_competitors).to_h
          ingest_competitors(data)
        end
        def ingest_competitors(data)
          @competitors_retrieved = true
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "sport_events"]
          data
        end
        def queue_schedule
          url, headers, options, timeout = api.get_request_info(path_schedule)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
        end

      end
    end
  end
end

__END__
"current_season"=>{"id"=>"sr:season:41988", "name"=>"Primeira Liga 17/18", "start_date"=>"2017-08-05", "end_date"=>"2018-05-31", "year"=>"17/18"}
"season_coverage_info"=>{"season_id"=>"sr:season:41988", "scheduled"=>306, "played"=>72, "max_coverage_level"=>"gold", "max_covered"=>72, "min_coverage_level"=>"gold"}


group = Sportradar::Api::Soccer::Group.new(league_group: 'eu')
res = group.get_tournaments;
tour = group.tournaments.sample
tour.get_seasons
tour
