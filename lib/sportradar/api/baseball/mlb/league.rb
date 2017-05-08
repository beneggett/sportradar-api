module Sportradar
  module Api
    module Baseball
      class Mlb
        class League < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id    = data["id"]
            @name  = data["name"]
            @alias = data["alias"]
            @divisions_hash = create_data({}, data["divisions"], klass: Division, conference: self, api: @api) # if response["division"]
          end

          def divisions
            @divisions_hash.values
          end

        end
      end
    end
  end
end

