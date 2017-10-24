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

          @groups_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @type           = data['type']
          @tie_break_rule = data['tie_break_rule'] if data['tie_break_rule']

          if data['groups']
            create_data(@groups_hash, data['groups'], klass: TeamGroup, api: api, identifier: 'name')
          end
        end

        def groups(name = nil)
          @groups_hash.values
        end

        def group(name = nil) # nil represents the complete team listing
          @groups_hash[name]
        end

        def teams
          @groups_hash.values.flat_map(&:teams)
        end

        def team(id)
          @groups_hash.values.flat_map(&:teams).detect { |team| team.id == id }
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

      end
    end
  end
end
