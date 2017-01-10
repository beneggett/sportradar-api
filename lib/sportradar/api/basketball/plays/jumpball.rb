module Sportradar
  module Api
    module Basketball
      class Jumpball < Play::Base
        alias :winner :team_id
        def display_type
          'Jumpball'
        end
      end
    end
  end
end
