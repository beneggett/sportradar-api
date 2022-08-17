module Sportradar
  module Api
    module Football
      class StatsShim
        attr_reader :game

        def initialize(game)
          @game = game
        end

        def dig(player_id, category, stat)
          game.team_stats.each_value do |stats|
            player = stats.public_send(category).for_player(player_id)
            if player
              return player.send(stat)
            end
          end
          nil
        end

      end
    end
  end
end
