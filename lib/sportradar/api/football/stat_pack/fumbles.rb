module Sportradar
  module Api
    class Football::StatPack::Fumbles < Football::StatPack
      attr_accessor :response, :fumbles, :lost_fumbles, :own_rec, :own_rec_yards, :opp_rec, :opp_rec_yards, :out_of_bounds, :forced_fumbles, :own_rec_tds, :opp_rec_tds, :ez_rec_tds

      def set_stats
        @response       = response[1] if response.is_a? Array
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
