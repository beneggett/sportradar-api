module Sportradar
  module Api
    class Nfl::Stat::KickReturns < Nfl::StatPack
      def set_stats(data)
        @returns           = data["returns"]
        @yards             = data["yards"]
        @avg_yards         = data["avg_yards"]
        @touchdowns        = data["touchdowns"]
        @longest           = data["longest"]
        @faircatches       = data["faircatches"]
        @longest_touchdown = data["longest_touchdown"]
      end
    end

  end
end
