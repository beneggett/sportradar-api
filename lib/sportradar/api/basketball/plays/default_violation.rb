module Sportradar
  module Api
    module Basketball
      class DefaultViolation < Play::Base
        def display_type
          'Default Violation'
        end
      end
    end
  end
end
