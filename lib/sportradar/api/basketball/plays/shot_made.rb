module Sportradar
  module Api
    module Basketball
      class ShotMade < Play::Base
        def made?
          true
        end
        def player_id
          @player_id ||= @statistics.dig(base_key, "player", "id")
        end
      end
    end
  end
end
