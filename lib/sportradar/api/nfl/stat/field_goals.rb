module Sportradar
  module Api
    class Nfl::Stat::FieldGoals < Nfl::StatPack
      def set_stats(data)
          @attempts  = data["attempts"]
          @made      = data["made"]
          @blocked   = data["blocked"]
          @yards     = data["yards"]
          @avg_yards = data["avg_yards"]
          @longest   = data["longest"]
      end
    end

  end
end