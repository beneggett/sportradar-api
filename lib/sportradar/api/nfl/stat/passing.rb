module Sportradar
  module Api
    class Nfl::Stat::Passing < Nfl::StatPack

      def set_stats(data)
        @attempts          = data["attempts"]
        @completions       = data["completions"]
        @cmp_pct           = data["cmp_pct"]
        @yards             = data["yards"]
        @avg_yards         = data["avg_yards"]
        @sacks             = data["sacks"]
        @sack_yards        = data["sack_yards"]
        @touchdowns        = data["touchdowns"]
        @longest           = data["longest"]
        @interceptions     = data["interceptions"]
        @rating            = data["rating"]
        @longest_touchdown = data["longest_touchdown"]
        @air_yards         = data["air_yards"]
        @redzone_attempts  = data["redzone_attempts"]
      end
    end

  end
end