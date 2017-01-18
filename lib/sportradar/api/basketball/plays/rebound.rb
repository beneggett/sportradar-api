module Sportradar
  module Api
    module Basketball
      class Rebound < Play::Base
        def base_key
          'rebound'
        end
        def display_type
          'Rebound'
        end
        def defensive?
          @rebound_type == 'defensive'
        end
        def offensive?
          @rebound_type == 'offensive'
        end
        def parse_statistics(data)
          super
          @rebound_type = @statistics.dig(base_key, 'rebound_type')
        end
      end
    end
  end
end
