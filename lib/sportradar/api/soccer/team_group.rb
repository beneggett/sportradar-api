module Sportradar
  module Api
    module Soccer
      class TeamGroup < Data
        attr_reader :league_group, :id, :name

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"] || data['name']
          @api          = opts[:api]
          @league_group = league_group || data['league_group'] || @api&.league_group

          @teams_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @name           = data['name']

          if team_data = (data['teams'] || data['team_standings'])
            create_data(@teams_hash, team_data, klass: Team, api: api)
          end
        end

        def teams
          @teams_hash.values
        end

        def team(id)
          @teams_hash[id]
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

      end
    end
  end
end
