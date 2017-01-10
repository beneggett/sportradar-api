module Sportradar
  module Api
    module Basketball
      class TechnicalFoul < Play::Base
        def base_key
          'technicalfoul'
        end
        def display_type
          'Technical'
        end
      end
    end
  end
end
