module Sportradar
  module Api
    module Football
      class Ncaafb
        class Play < Sportradar::Api::Football::Play


          def parsed_ending
            @parsed_ending ||= parse_description_for_drive_end
          end

        private

          def parse_description_for_drive_end
            parsed_ending = case @description
            when /intercepted/i
              :interception
            when /extra point is good/i
              :touchdown
            # when missed extra point
            when /punts/i
              :punt
            when /Field Goal is No Good. blocked/i
              :fg
            # when missed field goal
            when /Field Goal is Good/i
              :fg
            when "End of 1st Half"
              :end_of_half
            else
              #
            end
            if parsed_ending
              parsed_ending
            end
          end

        end
      end
    end
  end
end
