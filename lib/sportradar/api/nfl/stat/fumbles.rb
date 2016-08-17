module Sportradar
  module Api
    class Nfl::Stat::Fumbles < Nfl::StatPack
      def set_stats(data)
        data = data[1] if data.is_a? Array
        @fumbles        = data["fumbles"]
        @lost_fumbles   = data["lost_fumbles"]
        @own_rec        = data["own_rec"]
        @own_rec_yards  = data["own_rec_yards"]
        @opp_rec        = data["opp_rec"]
        @opp_rec_yards  = data["opp_rec_yards"]
        @out_of_bounds  = data["out_of_bounds"]
        @forced_fumbles = data["forced_fumbles"]
        @own_rec_tds    = data["own_rec_tds"]
        @opp_rec_tds    = data["opp_rec_tds"]
        @ez_rec_tds     = data["ez_rec_tds"]
      end
    end

  end
end