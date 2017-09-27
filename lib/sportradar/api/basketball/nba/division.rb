module Sportradar
  module Api
    module Basketball
      class Nba
        class Division < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @assigned_teams = nil
            @teams_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @id    = data["id"]
            @name  = data["name"]
            @alias = data["alias"]

            create_data(@teams_hash, data["teams"], klass: Team, division: self, api: @api) if response["teams"]
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
