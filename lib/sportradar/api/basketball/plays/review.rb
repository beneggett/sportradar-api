module Sportradar
  module Api
    module Basketball
      class Review < Play::Base
        def display_type
          'Review'
        end
      end
    end
  end
end
