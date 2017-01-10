module Sportradar
  module Api
    module Basketball
      class TeamTimeout < Timeout
        def display_type
          'Timeout'
        end
        def full?
          description.end_with? '60 second timeout'
        end
      end
    end
  end
end
