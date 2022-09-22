module Sportradar
  module Api
    module Mma
      class Season < Data
        attr_reader :id, :name, :start_date, :end_date, :year, :competition_id

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"]
          @api          = opts[:api]

          @fights_hash = {}
          @fighters_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @name           = data['name']            if data['name']
          @start_date     = Time.parse(data['start_date'])      if data['start_date']
          @end_date       = Time.parse(data['end_date'])        if data['end_date']
          @year           = data['year']            if data['year']
          @competition_id = data['competition_id']  if data['competition_id']

          parse_summary(data)
          parse_competitors(data)
        end

        def fights
          @fights_hash.values
        end

        def fighters
          @fighters_hash.values
        end

        def future?
          self.end_date > Time.now
        end

        def parse_summary(data)
          if data['summaries']
            create_data(@fights_hash, data['summaries'], klass: Fight, api: api, season: self)
          end
        end

        def parse_competitors(data)
          if data['season_competitors']
            create_data(@fighters_hash, data['season_competitors'], klass: Fighter, api: api, season: self)
          end
        end

        def api
          @api ||= Sportradar::Api::Mma::Api.new
        end

        # url path helpers
        def path_base
          "seasons/#{ id }"
        end

        def path_summary
          "#{ path_base }/summaries"
        end
        def get_summary
          data = api.get_data(path_summary).to_h
          ingest_summary(data)
        end
        def ingest_summary(data)
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "seasons"]
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
          update(data)
          # TODO parse the rest of the data. keys: ["tournament", "seasons"]
          data
        end

      end
    end
  end
end

__END__

{
  "id"=>"sr:season:54879",
  "name"=>"UFC Contender Series, Las Vegas, Week 26 2018",
  "start_date"=>"2018-06-26",
  "end_date"=>"2018-06-28",
  "year"=>"2018",
  "competition_id"=>"sr:competition:25357"
}
