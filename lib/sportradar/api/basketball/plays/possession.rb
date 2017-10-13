module Sportradar
  module Api
    module Basketball
      class Possession < Play::Base
        def display_type
          'Possession'
        end
      end
    end
  end
end
