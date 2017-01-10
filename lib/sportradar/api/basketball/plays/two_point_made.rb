module Sportradar
  module Api
    module Basketball
      class TwoPointMade < ShotMade
        def display_type
          '2PT Make'
        end
        def points
          2
        end
      end
    end
  end
end
