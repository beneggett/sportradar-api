module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Conference < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            # @response = data
            @api      = opts[:api]

            @id    = data["id"]
            @name  = data["name"]
            @alias = data["alias"]
            @assigned_teams = nil

            @teams_hash = create_data({}, data["teams"], klass: Team, conference: self, api: @api) # if data["team"]
          end

          def teams
            @assigned_teams || @teams_hash.values
          end
          def teams=(array)
            @assigned_teams = array
          end
          def team(code_name)
            teams_by_name[code_name]
          end
          private def teams_by_name
            @teams_by_name ||= teams.map { |t| [t.alias, t] }.to_h
          end
          def conferences
            teams.flat_map(&:conferences)
          end

        end
      end
    end
  end
end

