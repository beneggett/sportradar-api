module Sportradar
  module Api
    module Basketball
      class FreeThrowMiss < ShotMiss
        def base_key
          "freethrow"
        end
        def display_type
          'FT Miss'
        end
        def free_throw_type
          @free_throw_type ||= @statistics.dig(base_key, "free_throw_type")
        end
        def made?
          false
        end
        def player_id
          @player_id ||= @statistics&.dig(base_key, "player", "id") # safe operator is specifically for lane violations, which have no player_id and should not be assigned a player
        end
      end
    end
  end
end
