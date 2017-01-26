module Sportradar
  module Api
    module Basketball
      class ShotMiss < Play::Base
        attr_reader :shot_type, :shot_type_desc, :block
        def base_key
          "fieldgoal"
        end
        def parse_statistics(data)
          super
          @shot_type = @statistics.dig(base_key, 'shot_type')
          @shot_type_desc = @statistics.dig(base_key, 'shot_type_desc')
          @block = Block.new(data, quarter: @quarter, half: @half) if @statistics['block']
        end
        def made?
          false
        end
      end
    end
  end
end
