module Sportradar
  module Api
    module Basketball
      class Block < Play::Base
        def base_key
          'block'
        end
        def display_type
          'Block'
        end
      end
    end
  end
end
