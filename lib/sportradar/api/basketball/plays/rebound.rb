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
          stat = @statistics.dig(base_key)
          stat = stat[0] if stat.is_a?(Array)
          @rebound_type = stat['rebound_type']
        rescue => e
          # noop => bad data from SR
        end
      end
    end
  end
end
