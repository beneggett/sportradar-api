module Sportradar
  module Api
    class Nfl::Stat::Punts < Nfl::StatPack
      attr_accessor :avg_yards, :yards, :attempts, :blocked, :longest, :touchbacks, :inside_20, :avg_net_yards, :return_yards, :net_yards

      def set_stats
        @avg_yards     = response["avg_yards"]
        @yards         = response["yards"]
        @attempts      = response["attempts"]
        @blocked       = response["blocked"]
        @longest       = response["longest"]
        @touchbacks    = response["touchbacks"]
        @inside_20     = response["inside_20"]
        @avg_net_yards = response["avg_net_yards"]
        @return_yards  = response["return_yards"]
        @net_yards     = response["net_yards"]
      end
    end

  end
end
