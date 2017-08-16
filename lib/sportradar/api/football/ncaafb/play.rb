module Sportradar
  module Api
    module Football
      class Ncaafb
        class Play < Sportradar::Api::Football::Play


          def parsed_ending
            @parsed_ending ||= parse_description_for_drive_end
          end


          def queue_details
            if @details
              url, headers, options, timeout = @api.get_request_info(@details)
              {url: url, headers: headers, params: options, timeout: timeout, callback: method(:update)}
            end
          end

          def get_details
            if @details
              data = @api.get_data(@details).to_h
              update(data)
              data
            end
          end

        private

          def parse_description_for_drive_end
            parsed_ending = case @description
            when /intercepted/i
              :interception
            when /fumbles/i
              :fumble
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
