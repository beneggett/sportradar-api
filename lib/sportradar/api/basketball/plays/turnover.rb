module Sportradar
  module Api
    module Basketball
      class Turnover < Play::Base
        attr_reader :steal
        def base_key
          'turnover'
        end
        def display_type
          'Turnover'
        end
        def parse_statistics(data)
          super
          @steal = Steal.new(data, quarter: @quarter) if @statistics['steal']
        end
      end
    end
  end
end
