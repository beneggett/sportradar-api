module Sportradar
  module Api
    module Football
      class Nfl
        class Division < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id = data["id"]
            @teams_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @name   = data["name"]
            @alias  = data["alias"]
            create_data(@teams_hash, data["teams"], klass: Team, division: self, api: @api)

            self
          end

          def teams
            @assigned_teams || @teams_hash.values
          end
          def teams=(array)
            @assigned_teams = array
          end

        end
      end
    end
  end
end
