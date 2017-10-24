module Sportradar
  module Api
    module Soccer
      class Standing < Data
        attr_reader :league_group, :id, :type

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data["id"] || data['type']
          @api          = opts[:api]
          @league_group = league_group || data['league_group'] || @api&.league_group

          @teams_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @type           = data['type']
          @tie_break_rule = data['tie_break_rule'] if data['tie_break_rule']

          if group_data = data.dig('groups', 0, 'team_standings') # this should be looked into more, see if there's ever more than 1 item in the array
            team_data = group_data.map { |hash| hash['team'] }
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
