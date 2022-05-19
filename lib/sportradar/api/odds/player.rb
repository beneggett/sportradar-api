module Sportradar
  module Api
    module Odds
      class Player < Data
        attr_accessor :response, :api, :id


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @id       = data['id'] || data.dig('player', 'id')

          @props_hash = {}

          update(data['player'])  if data['player']
          update(data)
        end

        def update(data, **opts)
          # @name ||= data['name'] if data['name']

          create_data(@props_hash, data['markets'], klass: Player, api: api) if data['markets']
        end

      end
    end
  end
end

