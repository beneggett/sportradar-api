module Sportradar
  module Api
    class Football::StatPack::IntReturns < Football::StatPack
      attr_accessor :returns, :yards, :avg_yards, :touchdowns, :longest, :longest_touchdown

      def set_stats
        @returns           = response["returns"]
        @yards             = response["yards"]
        @avg_yards         = response["avg_yards"]
        @touchdowns        = response["touchdowns"]
        @longest           = response["longest"]
        @longest_touchdown = response["longest_touchdown"]
      end
    end

  end
end
