module Sportradar
  module Api
    module Football
      class Ncaafb
        class Play < Sportradar::Api::Football::Play


          def parsed_ending
            @parsed_ending ||= search_for_drive_end
          end

          def counted_play?
            ['rush', 'pass'].include?(self.play_type) && !self.description.include?('No Play')
          end

          def halftime?
            @description == "End of 1st Half"
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

          def search_for_drive_end
            case @play_type
            when 'kick'
              nil
            when 'rush'
              # check for fumble
              parse_description_for_drive_end
            when 'pass'
              # check for fumble/interception
              parse_description_for_drive_end
            when 'punt'
              :punt
            when 'penalty'
              nil
            when 'fieldgoal'
              :fg
            when 'extrapoint'
              :pat
            else
              parse_description_for_drive_end
            end
          end

          # ["kick", "rush", "pass", "punt", "penalty", nil, "fieldgoal", "extrapoint"]
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
            when /Field Goal is No Good/i
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

__END__

{"id"=>"694bb030-be6c-4b6f-a77d-1ea103749463", "game"=>"b3dca62c-f306-4fb8-9856-808e7b42a89f", "type"=>"pass", "official"=>true, "clock"=>":29", "quarter"=>3, "controller"=>"FLA", "updated"=>"2015-08-12T17:03:19+00:00", "formation"=>"Shotgun", "direction"=>"Right", "distance"=>"Short", "summary"=>"6-J.Driskel complete to 11-D.Robinson. 11-D.Robinson runs 9 yards for a touchdown.", "start_situation"=>{"team"=>"FLA", "side"=>"KEN", "yard_line"=>9, "down"=>2, "yfd"=>9}, "end_situation"=>{"team"=>"FLA", "side"=>"KEN", "yard_line"=>2}, "advancements"=>[{"type"=>"progression", "sequence"=>1, "team"=>"FLA", "from"=>{"side"=>"KEN", "yard_line"=>9}, "to"=>{"side"=>"KEN", "yard_line"=>0}}], "score"=>{"type"=>"touchdown", "points"=>6, "team"=>"FLA"}, "players"=>[{"id"=>"55bf8c60-6953-4d83-9982-7e38ff867130", "name"=>"Jeff Driskel", "jersey"=>6, "position"=>"QB", "team"=>"FLA", "passing"=>{"att"=>1, "cmp"=>1, "yds"=>9, "sk"=>0, "sk_yds"=>0, "td"=>1, "int"=>0, "fd"=>1, "sfty"=>0, "rz_att"=>1}}, {"id"=>"9252aab2-b175-4e2f-974d-dc7f6f8c3b3a", "name"=>"Demarcus Robinson", "jersey"=>11, "position"=>"WR", "team"=>"FLA", "receiving"=>{"tar"=>1, "rec"=>1, "yds"=>9, "yac"=>9, "td"=>1, "fum"=>0, "fd"=>1, "rz_tar"=>1}}]}
