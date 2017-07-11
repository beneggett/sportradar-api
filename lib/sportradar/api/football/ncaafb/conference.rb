module Sportradar
  module Api
    module Football
      class Ncaafb
        class Conference < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id    = data["id"]
            @name  = data["name"]
            @alias = data["alias"]
            @teams_hash = {}
            @subdivisions_hash = {}
            @assigned_teams = nil
            # binding.pry

            create_data(@teams_hash, data["teams"], klass: Team, conference: self, api: @api) if data["teams"]
            create_data(@subdivisions_hash, data["subdivisions"], klass: Subdivision, conference: self, api: @api) if data["subdivisions"]
          end

          def teams
            @assigned_teams || begin
              if !@subdivisions_hash.empty?
                @subdivisions_hash.each_value.flat_map(&:teams)
              elsif !@teams_hash.empty?
                @teams_hash.values
              else
                []
              end
            end
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

