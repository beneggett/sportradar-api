module Sportradar
  module Api
    module Basketball
      class JumpballViolation < Play::Base
        def display_type
          'Jump Ball Violation'
        end
      end
    end
  end
end
