module Sportradar
  module Api
    class Nfl::Stat::FieldGoals < Nfl::StatPack
      attr_accessor :attempts, :made, :blocked, :yards, :avg_yards, :longest

      def set_stats
        @attempts  = response["attempts"]
        @made      = response["made"]
        @blocked   = response["blocked"]
        @yards     = response["yards"]
        @avg_yards = response["avg_yards"]
        @longest   = response["longest"]
      end
    end

  end
end
