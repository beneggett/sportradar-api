module Sportradar
  module Api
    module Basketball
      class Nba
        class Conference < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @divisions_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @id    = data["id"]
            @name  = data["name"]
            @alias = data["alias"]

            create_data(@divisions_hash, data["divisions"], klass: Division, conference: self, api: @api) if response["divisions"]
          end

          def divisions
            @divisions_hash.values
          end

        end
      end
    end
  end
end

