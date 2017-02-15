module Sportradar
  module Api
    module Basketball
      class Nba
        class Division < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id = data["id"]
            @name = data["name"]
            @alias = data["alias"]
            @assigned_teams = nil
            @teams_hash = create_data({}, data["teams"], klass: Team, division: self, api: @api) # if response["team"]
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
