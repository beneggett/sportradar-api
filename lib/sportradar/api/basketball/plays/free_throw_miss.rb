module Sportradar
  module Api
    module Basketball
      class FreeThrowMiss < Play::Base
        BASE_KEY = "freethrow"
        def free_throw_type
          @free_throw_type ||= @statistics.dig(BASE_KEY, "free_throw_type")
        end
        def made?
          false
        end
        def points
          0
        end
        def player_id
          @player_id ||= @statistics.dig(BASE_KEY, "player", "id")
        end
      end
    end
  end
end
