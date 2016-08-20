module Sportradar
  module Api
    class Nfl::Stat::Passing < Nfl::StatPack
      attr_accessor :attempts, :completions, :cmp_pct, :yards, :avg_yards, :sacks, :sack_yards, :touchdowns, :longest, :interceptions, :rating, :longest_touchdown, :air_yards, :net_yards, :redzone_attempts

      def set_stats
        @attempts          = response["attempts"]
        @completions       = response["completions"]
        @cmp_pct           = response["cmp_pct"]
        @yards             = response["yards"]
        @avg_yards         = response["avg_yards"]
        @sacks             = response["sacks"]
        @sack_yards        = response["sack_yards"]
        @touchdowns        = response["touchdowns"]
        @longest           = response["longest"]
        @interceptions     = response["interceptions"]
        @rating            = response["rating"]
        @longest_touchdown = response["longest_touchdown"]
        @air_yards         = response["air_yards"]
        @net_yards         = response["net_yards"] # passing net_yards is the correct measure for team stats, as it includes sack yardage. that is how NFL counts team yardage
        @redzone_attempts  = response["redzone_attempts"]
      end
    end

  end
end
