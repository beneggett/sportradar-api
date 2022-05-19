module Sportradar
  module Api
    module Odds
      class SportEvent < Data
        attr_accessor :response, :api, :id


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @id       = data['id'] || data.dig('sport_event', 'id')

          @player_props_hash     = {}
          @player_markets_hash   = {}

          update(data)
          # update(data['sport_event'])       if data['sport_event']
          # update(data['players_props'])     if data['players_props']
          # update(data['players_markets'])   if data['players_markets']
        end

        def player_props
          @player_props_hash.values
        end

        def player_markets
          @player_markets_hash.values
        end

        def update(data, **opts)
          create_data(@player_props_hash,   data['players_props'],    klass: PlayerProp,  api: api)  if data['players_props']
          create_data(@player_markets_hash, data['players_markets'],  klass: Market,      api: api)  if data['players_markets']
        rescue => e
          binding.pry
        end

      end
    end
  end
end
