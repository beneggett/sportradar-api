module Sportradar
  module Api
    module Basketball
      class EndPeriod < Play::Base

        def quarter_break?
          ["End of 1st Quarter.", "End of 3rd Quarter."].include? description
        end
        def halftime?
          description == 'End of 1st Half.'
        end
      end
    end
  end
end
