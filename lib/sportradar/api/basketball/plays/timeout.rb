module Sportradar
  module Api
    module Basketball
      class Timeout < Play::Base
        def timeout?
          true
        end
      end
    end
  end
end
