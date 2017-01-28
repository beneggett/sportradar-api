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
          stat = @statistics.detect { |hash| hash['type'] == base_key }
          @shot_type =      stat['shot_type']
          @shot_type_desc = stat['shot_type_desc']
          @block = Block.new(data, quarter: @quarter, half: @half) if @statistics.detect { |hash|  hash['type'] == 'block' }
        rescue => e
          binding.pry
        end
        def made?
          false
        end
      end
    end
  end
end
