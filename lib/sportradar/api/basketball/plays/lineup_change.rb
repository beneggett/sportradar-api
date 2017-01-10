module Sportradar
  module Api
    module Basketball
      class LineupChange < Play::Base
        def display_type
          'Substitution'
        end
      end
    end
  end
end
