module Sportradar
  module Api
    class Nfl::Stat::Rushing < Nfl::StatPack
      def set_stats(data)
        @avg_yards         = data["avg_yards"]
        @yards             = data["yards"]
        @touchdowns        = data["touchdowns"]
        @longest           = data["longest"]
        @longest_touchdown = data["longest_touchdown"]
        @attempts          = data["attempts"]
        @tlost             = data["tlost"]
        @tlost_yards       = data["tlost_yards"]
        @redzone_attempts  = data["redzone_attempts"]
      end
    end
  end
end