module Sportradar
  module Api
    module Football
      class Ncaafb
        class Play < Sportradar::Api::Football::Play

          def play_type
            if @play_type.nil?
              nil
            elsif @play_type.casecmp? 'kick'
              'kickoff'
            elsif @play_type.casecmp? 'extrapoint'
              'extra point'
            elsif @play_type.casecmp? 'fieldgoal'
              'field goal'
            else
              super
            end
          end

          def clock_seconds
            m,s = @clock.split(':')
            m.to_i * 60 + s.to_i
          end

          def made_first_down?
            statistics.pass&.first&.firstdown == 1 || statistics.rush&.first&.firstdown == 1
          end

          def yards
            (counted_play? && (statistics.pass&.first || statistics.rush&.first)&.yards).to_i
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
              @detailed_data = @api.get_data(@details).to_h
              update(@detailed_data)
              @detailed_data
            end
          end

        private

          # def search_for_drive_end
          #   case @play_type
          #   when 'kick'
          #     nil
          #   when 'rush'
          #     # check for fumble
          #     parse_description_for_drive_end
          #   when 'pass'
          #     # check for fumble/interception
          #     parse_description_for_drive_end
          #   when 'punt'
          #     :punt
          #   when 'penalty'
          #     nil
          #   when 'fieldgoal'
          #     :fg
          #   when 'extrapoint'
          #     :pat
          #   else
          #     parse_description_for_drive_end
          #   end
          # end

          # ["kick", "rush", "pass", "punt", "penalty", nil, "fieldgoal", "extrapoint"]
          def parse_description_for_drive_end
            parsed_ending = case @description
            when /no play/i
              nil
            when /intercepted/i
              :interception
            when /fumbles/i
              self.statistics&.fumble&.first&.lost? && :fumble
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

{"id"=>"35a85f6d-6768-4cf3-9dbb-0e1d5ef1a8d1",
 "game"=>"f6991379-ca3a-4719-b247-505735e357a2",
 "type"=>"kick",
 "official"=>true,
 "clock"=>"07:50",
 "quarter"=>2,
 "controller"=>"MSH",
 "updated"=>"2015-08-12T19:47:43+00:00",
 "summary"=>"30-K.Vedvik kicks 56 yards from MSH 35. 81-K.Towner to WKY 24 for 15 yards.",
 "start_situation"=>{"team"=>"MSH", "side"=>"MSH", "yard_line"=>35},
 "end_situation"=>{"team"=>"WKY", "side"=>"WKY", "yard_line"=>24, "down"=>1, "yfd"=>10},
 "advancements"=>
  [{"type"=>"progression", "sequence"=>1, "team"=>"MSH", "from"=>{"side"=>"MSH", "yard_line"=>35}, "to"=>{"side"=>"WKY", "yard_line"=>9}},
   {"type"=>"progression", "sequence"=>2, "team"=>"WKY", "from"=>{"side"=>"WKY", "yard_line"=>9}, "to"=>{"side"=>"WKY", "yard_line"=>24}}],
 "players"=>
  [{"id"=>"bb333d66-eca4-48cc-8a25-f674e7c5e519", "name"=>"Kylen Towner", "jersey"=>81, "position"=>"WR", "team"=>"WKY", "kick_return"=>{"returns"=>1, "yds"=>15, "fc"=>0, "td"=>0}},
   {"id"=>"cb47dc0b-c133-428a-8afb-1706f18e9e8e", "name"=>"Kaare Vedvik", "jersey"=>30, "position"=>"K", "team"=>"MSH", "kickoffs"=>{"kicks"=>1, "yds"=>56, "net_yds"=>41, "endzone"=>0, "in20"=>0, "tb"=>0, "ret"=>1}}]}
