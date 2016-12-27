module Sportradar
  module Api
    module Basketball
      class TechnicalFoul < Play::Base
        def base_key
          'technicalfoul'
        end
      end
    end
  end
end
