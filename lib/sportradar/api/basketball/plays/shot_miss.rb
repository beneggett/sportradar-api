module Sportradar
  module Api
    module Basketball
      class ShotMiss < Play::Base
        def made?
          false
        end
        def player_id
          @player_id ||= @statistics.dig(base_key, "player", "id")
        end
      end
    end
  end
end
