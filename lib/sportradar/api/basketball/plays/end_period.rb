module Sportradar
  module Api
    module Basketball
      class EndPeriod < Play::Base
        def display_type
          ''
        end

        def end_of_period?
          true
        end

        def quarter_break?
          ["End of 1st Quarter.", "End of 3rd Quarter."].include? description
        end
        def end_of_regulation?
          description == "End of 4th Quarter." || description == "End of 2nd Half."
        end
        def end_of_ot?
          description.start_with?("End of ") && description.end_with?(" OT.")
        end
        def halftime?
          description == 'End of 1st Half.'
        end
      end
    end
  end
end
