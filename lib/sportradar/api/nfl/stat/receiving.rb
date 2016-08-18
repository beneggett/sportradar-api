module Sportradar
  module Api
    class Nfl::Stat::Receiving < Nfl::StatPack
      def set_stats(data)
        @avg_yards         = data["avg_yards"]
        @yards             = data["yards"]
        @touchdowns        = data["touchdowns"]
        @longest           = data["longest"]
        @longest_touchdown = data["longest_touchdown"]
        @targets           = data["targets"]
        @receptions        = data["receptions"]
        @yards_after_catch = data["yards_after_catch"]
        @redzone_targets   = data["redzone_targets"]
        @air_yards         = data["air_yards"]
      end
    end

  end
end
