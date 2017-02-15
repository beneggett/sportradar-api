module Sportradar
  module Api
    module Basketball
      class ShotMade < Play::Base
        attr_reader :shot_type, :shot_type_desc, :assist
        def base_key
          "fieldgoal"
        end
        def parse_statistics(data)
          super
          stat = @statistics.detect { |hash| hash['type'] == base_key }
          @shot_type = stat['shot_type']
          @shot_type_desc = stat['shot_type_desc']
          @assist = Assist.new(data, quarter: @quarter, half: @half) if @statistics.detect { |hash|  hash['type'] == 'assist' }
        end
        def made?
          true
        end
      end
    end
  end
end
