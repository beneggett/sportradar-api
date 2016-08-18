module Sportradar
  module Api
    class Nfl::Stat::Kickoffs < Nfl::StatPack
      def set_stats(data)
        @kickoffs      = data["kickoffs"]
        @endzone       = data["endzone"]
        @inside_20     = data["inside_20"]
        @return_yards  = data["return_yards"]
        @touchbacks    = data["touchbacks"]
        @yards         = data["yards"]
        @out_of_bounds = data["out_of_bounds"]
      end
    end

  end
end
