module Sportradar
  module Api
    module Football
      class Nfl
        class Play < Sportradar::Api::Football::Play

          def play?
            @event_type.nil?
          end

          def down
            start_situation.down
          end

          def yfd
            start_situation.yfd
          end
          # def parse_player
          #   # TODO: Currently there is an issue where we are only mapping one player_id to a play, but there are plays with multiple players involved.
          #   play_stats = @statistics.penalty || @statistics.rush || @statistics.return || @statistics.receive
          #   if play_stats.is_a?(Array)
          #     play_stats = play_stats.first
          #   end
          #   @player_id = play_stats&.player&.id
          # end

        end
      end
    end
  end
end
