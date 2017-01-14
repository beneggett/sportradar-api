module Sportradar
  module Api
    module Basketball
      class FreeThrowMade < ShotMade
        def base_key
          "freethrow"
        end
        def display_type
          'FT Made'
        end
        def free_throw_type
          @free_throw_type ||= @statistics.dig(base_key, "free_throw_type")
        end
        def made?
          true
        end
        def points
          1
        end
      end
    end
  end
end
