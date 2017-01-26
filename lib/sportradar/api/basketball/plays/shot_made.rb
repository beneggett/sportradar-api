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
          @shot_type = @statistics.dig(base_key, 'shot_type')
          @shot_type_desc = @statistics.dig(base_key, 'shot_type_desc')
          @assist = Assist.new(data, quarter: @quarter, half: @half) if @statistics['assist']
        end
        def made?
          true
        end
      end
    end
  end
end
