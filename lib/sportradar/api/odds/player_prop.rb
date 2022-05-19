module Sportradar
  module Api
    module Odds
      class PlayerProp < Data
        attr_accessor :response, :api, :id


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @id       = data.dig("player", "id")

          @markets_hash   = {}

          update(data, **opts)
        end

        def markets
          @markets_hash.values
        end

        def update(data, **opts)
          create_data(@markets_hash,   data['markets'],    klass: Market,  api: api, player: data['player'])  if data['markets']
        end

      end
    end
  end
end
