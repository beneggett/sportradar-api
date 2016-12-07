module Sportradar
  module Api
    class Ncaafb
      class Play < Data
        attr_accessor :response, :id, :sequence, :reference, :clock, :home_points, :away_points, :type, :play_clock, :wall_clock, :start_situation, :end_situation, :description, :alt_description, :statistics, :score, :scoring_play, :team_id, :player_id

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @drive    = opts[:drive]

          @id           = response['id']           # "4ddaf72b-c959-40c1-8bbb-0cd7ee6a32d9",
          @clock        = response['clock']        # "15:00",
          @type         = response['type']         # "kick",
          @sequence     = response['sequence']     # "2",
          @updated      = response['updated']      # "2016-08-27T21:19:31+00:00",
          @side         = response['side']         # "HAW",
          @yard_line    = response['yard_line']    # "48",
          @down         = response['down']         # "1",
          @yfd          = response['yfd']          # "10",
          @summary      = response['summary']      # "kicks 13 yards from HAW 35 to the HAW 48, downed by 28-P.Laird to HAW 48 for no gain (28-C.Hayes).",
          @links        = structure_links(response['links'])        # {"link"=>{"rel"=>"summary", "href"=>"/2016/REG/1/HAW/CAL/plays/4ddaf72b-c959-40c1-8bbb-0cd7ee6a32d9.xml", "type"=>"application/xml"}}}
          @participants = response['participants'] # {"player"=>[{"id"=>"5062ed5a-c920-4350-8be4-e32ac7b0b27b", "name"=>"Patrick Laird", "jersey"=>"28", "position"=>"RB", "team"=>"CAL"}, {"id"=>"0b0548c8-456f-4d6a-b3d1-f4f386b952e7", "name"=>"Cameron Hayes", "jersey"=>"28", "position"=>"DB", "team"=>"HAW"}]},

        end

        def parse_player
          # TODO: Currently there is an issue where we are only mapping one player_id to a play, but there are plays with multiple players involved.
          play_stats = @statistics.penalty || @statistics.rush || @statistics.return || @statistics.receive
          if play_stats.is_a?(Array)
            play_stats = play_stats.first
          end
          @player_id = play_stats.dig('player', 'id') if play_stats
        end

      end
    end
  end
end
