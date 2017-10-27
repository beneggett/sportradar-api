module Sportradar
  module Api
    module Soccer
      class TeamGroup < Data
        attr_reader :league_group, :id, :name, :tournament_id

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
          get_tournament_id(data, **opts)

          if team_data = (data['teams'] || data['team_standings'])
            create_data(@teams_hash, team_data, klass: Team, api: api, tournament: opts[:tournament], team_group: self)
          end
        end

        def get_tournament_id(data, **opts)
          @tournament_id ||= if opts[:tournament]
            opts[:tournament].id
          elsif opts[:season]
            opts[:season].tournament_id
          elsif opts[:match]
            opts[:match].tournament_id
          elsif data['tournament']
            data.dig('tournament', 'id')
          elsif data['season']
            data.dig('season', 'tournament_id')
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
