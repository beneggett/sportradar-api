module Sportradar
  module Api
    module Odds
      class BookMarket < Data
        attr_accessor :response, :id, :book_id, :book_name, :removed, :external_sport_event_id, :external_market_id


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @id       = data['external_market_id']
          @market   = opts[:market]
          @outcomes_hash = {}

          update(data, **opts)
        end

        def outcomes
          @outcomes_hash.values
        end

        def update(data, **opts)
          @book_id                 = data['id']                       if data['id']                      # "sr:book:17324",
          @book_name               = data['name']                     if data['name']                    # "MGM",
          @removed                 = data['removed']                  if data['removed']                 # false,
          @external_sport_event_id = data['external_sport_event_id']  if data['external_sport_event_id'] # "12959106",
          @external_market_id      = data['external_market_id']       if data['external_market_id']      # "773486499",

          create_data(@outcomes_hash, data['outcomes'], klass: Outcome, api: @api) if data['outcomes']
        end

      end
    end
  end
end


