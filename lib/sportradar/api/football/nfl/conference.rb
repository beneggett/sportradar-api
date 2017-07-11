module Sportradar
  module Api
    module Football
      class Nfl
        class Conference < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id = data["id"]
            @divisions_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @name   = data["name"]  if data["name"]
            @alias  = data["alias"] if data["alias"]
            create_data(@divisions_hash, data["divisions"], klass: Division, conference: self, api: @api)

            self
          end

          def divisions
            @divisions_hash.values
          end

        end
      end
    end
  end
end

