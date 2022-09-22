module Sportradar
  module Api
    module Mma
      class Competition < Data
        attr_reader :id, :name, :parent_id, :category

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"]
          @api          = opts[:api]

          @name         = data['name']      if data['name']
          @parent_id    = data['parent_id'] if data['parent_id']
          @category     = data['category']  if data['category']

          @seasons_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          parse_season(data)
        end

        def parse_season(data)
          if data['seasons']
            create_data(@seasons_hash, data['seasons'], klass: Season, api: api, competition: self)
          end
        end

        def seasons
          @seasons_hash.values
        end

        def api
          @api ||= Sportradar::Api::Mma::Api.new
        end

        # url path helpers
        def path_base
          "competitions/#{ id }"
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

      end
    end
  end
end

__END__
