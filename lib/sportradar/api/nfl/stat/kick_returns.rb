module Sportradar
  module Api
    class Nfl::Stat::KickReturns < Nfl::StatPack
      attr_accessor :returns, :yards, :avg_yards, :touchdowns, :longest, :faircatches, :longest_touchdown

      def set_stats
        @returns           = response["returns"]
        @yards             = response["yards"]
        @avg_yards         = response["avg_yards"]
        @touchdowns        = response["touchdowns"]
        @longest           = response["longest"]
        @faircatches       = response["faircatches"]
        @longest_touchdown = response["longest_touchdown"]
      end
    end

  end
end
