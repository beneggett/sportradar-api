module Sportradar
  module Api
    module Basketball
      class TeamTimeout < Timeout
        def display_type
          'Timeout'
        end
      end
    end
  end
end
