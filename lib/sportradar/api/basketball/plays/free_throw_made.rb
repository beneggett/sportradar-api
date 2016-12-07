module Sportradar
  module Api
    module Basketball
      class FreeThrowMade < Play::Base
        BASE_KEY = "freethrow"
        def free_throw_type
          @free_throw_type ||= @statistics.dig(BASE_KEY, "free_throw_type")
        end
        def made?
          true
        end
        def points
          1
        end
        def player_id
          @player_id ||= @statistics.dig(BASE_KEY, "player", "id")
        end
      end
    end
  end
end
