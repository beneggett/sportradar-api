module Sportradar
  module Api
    class Nfl::Stat::Fumbles < Nfl::StatPack
      def set_stats(data)
        @response       = data[1] if data.is_a? Array
        @fumbles        = response["fumbles"]
        @lost_fumbles   = response["lost_fumbles"]
        @own_rec        = response["own_rec"]
        @own_rec_yards  = response["own_rec_yards"]
        @opp_rec        = response["opp_rec"]
        @opp_rec_yards  = response["opp_rec_yards"]
        @out_of_bounds  = response["out_of_bounds"]
        @forced_fumbles = response["forced_fumbles"]
        @own_rec_tds    = response["own_rec_tds"]
        @opp_rec_tds    = response["opp_rec_tds"]
        @ez_rec_tds     = response["ez_rec_tds"]
      end
    end

  end
end
