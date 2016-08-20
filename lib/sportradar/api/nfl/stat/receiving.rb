module Sportradar
  module Api
    class Nfl::Stat::Receiving < Nfl::StatPack
      attr_accessor :avg_yards, :yards, :touchdowns, :longest, :longest_touchdown, :targets, :receptions, :yards_after_catch, :redzone_targets, :air_yards

      def set_stats
        @avg_yards         = response["avg_yards"]
        @yards             = response["yards"]
        @touchdowns        = response["touchdowns"]
        @longest           = response["longest"]
        @longest_touchdown = response["longest_touchdown"]
        @targets           = response["targets"]
        @receptions        = response["receptions"]
        @yards_after_catch = response["yards_after_catch"]
        @redzone_targets   = response["redzone_targets"]
        @air_yards         = response["air_yards"]
      end
    end

  end
end
