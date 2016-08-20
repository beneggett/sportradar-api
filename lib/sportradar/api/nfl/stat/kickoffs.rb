module Sportradar
  module Api
    class Nfl::Stat::Kickoffs < Nfl::StatPack
      attr_accessor :kickoffs, :endzone, :inside_20, :return_yards, :touchbacks, :yards, :out_of_bounds

      def set_stats
        @kickoffs      = response["kickoffs"]
        @endzone       = response["endzone"]
        @inside_20     = response["inside_20"]
        @return_yards  = response["return_yards"]
        @touchbacks    = response["touchbacks"]
        @yards         = response["yards"]
        @out_of_bounds = response["out_of_bounds"]
      end
    end

  end
end
