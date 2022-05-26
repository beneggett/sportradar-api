module Sportradar
  module Api
    module Odds
      class Market < Data
        attr_accessor :response, :id, :name, :player


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @id       = data['id']
          @name     = data['name']
          @player   = opts['player']

          @book_markets_hash = {}

          update(data, **opts)
        end

        def book_markets
          @book_markets_hash.values
        end

        def update(data, **opts)
          create_data(@book_markets_hash, data['books'], klass: BookMarket, api: @api, market: self, player: @player) if data['books']
        end

      end
    end
  end
end


