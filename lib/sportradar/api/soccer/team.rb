module Sportradar
  module Api
    module Soccer
      class Team < Data
        attr_reader :id, :league_group, :name, :country, :country_code, :abbreviation, :qualifier

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id']
          @api          = opts[:api]
          @league_group = league_group || data['league_group'] || @api&.league_group

          update(data, **opts)
        end

        def update(data, **opts)
          @league_group = opts[:league_group] || data['league_group'] || @league_group

          @name         = data['name']
          @country      = data['country']
          @country_code = data['country_code']
          @abbreviation = data['abbreviation']
          @qualifier    = data['qualifier']
        end

        def api
          @api || Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

      end
    end
  end
end
