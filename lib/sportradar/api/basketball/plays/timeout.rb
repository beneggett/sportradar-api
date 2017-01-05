module Sportradar
  module Api
    module Basketball
      class Timeout < Play::Base
        attr_writer :media_timeout
        def timeout?
          true
        end
        def media_timeout?
          @media_timeout
        end
      end
    end
  end
end
