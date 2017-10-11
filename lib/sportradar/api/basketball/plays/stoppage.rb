module Sportradar
  module Api
    module Basketball
      class Stoppage < Play::Base
        def display_type
          'Stoppage'
        end
      end
    end
  end
end
