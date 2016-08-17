module Sportradar
  module Api
    class Nfl::Stat::Punts < Nfl::StatPack
      def set_stats(data)
        @avg_yards     = data["avg_yards"]
        @yards         = data["yards"]
        @attempts      = data["attempts"]
        @blocked       = data["blocked"]
        @longest       = data["longest"]
        @touchbacks    = data["touchbacks"]
        @inside_20     = data["inside_20"]
        @avg_net_yards = data["avg_net_yards"]
        @return_yards  = data["return_yards"]
        @net_yards     = data["net_yards"]
      end
    end

  end
end