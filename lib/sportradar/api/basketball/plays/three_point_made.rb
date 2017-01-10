module Sportradar
  module Api
    module Basketball
      class ThreePointMade < ShotMade
        def display_type
          '3PT Make'
        end
        def points
          3
        end
      end
    end
  end
end
