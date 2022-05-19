module Sportradar
  module Api
    module Odds
      class RegularOdds
        #

        def self.api_base
          "oddscomparison-#{package}"
        end

        def self.package
          # read ENV
          'us'
        end
      end
    end
  end
end
