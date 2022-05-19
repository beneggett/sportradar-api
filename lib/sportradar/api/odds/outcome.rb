module Sportradar
  module Api
    module Odds
      class Outcome < Data
        attr_accessor :response, :id
        attr_accessor :type, :odds_decimal, :odds_american, :odds_fraction, :open_odds_decimal, :open_odds_american, :open_odds_fraction, :total, :open_total, :external_outcome_id, :removed


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @id       = data['id']

          update(data, **opts)
        end

        def update(data, **opts)
          @type                 = data['type']                  if data['type']
          @odds_decimal         = data['odds_decimal']          if data['odds_decimal']
          @odds_american        = data['odds_american']         if data['odds_american']
          @odds_fraction        = data['odds_fraction']         if data['odds_fraction']
          @open_odds_decimal    = data['open_odds_decimal']     if data['open_odds_decimal']
          @open_odds_american   = data['open_odds_american']    if data['open_odds_american']
          @open_odds_fraction   = data['open_odds_fraction']    if data['open_odds_fraction']
          @total                = data['total']                 if data['total']
          @open_total           = data['open_total']            if data['open_total']
          @external_outcome_id  = data['external_outcome_id']   if data['external_outcome_id']
          @removed              = data['removed']               if data['removed']
        end

      end
    end
  end
end
