module Sportradar
  module Api
    module Basketball
      class Ejection < Play::Base
        def base_key
          'ejection'
        end
        def display_type
          'Ejection'
        end
      end
    end
  end
end
