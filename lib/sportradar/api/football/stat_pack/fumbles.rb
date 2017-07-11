module Sportradar
  module Api
    class Football::StatPack::Fumbles < Football::StatPack
      attr_accessor :response, :fumbles, :lost_fumbles, :own_rec, :own_rec_yards, :opp_rec, :opp_rec_yards, :out_of_bounds, :forced_fumbles, :own_rec_tds, :opp_rec_tds, :ez_rec_tds

      def set_stats
        @response       = response[1] if response.is_a? Array
        @fumbles        = response["fumbles"] || response['fum']
        @lost_fumbles   = response["lost_fumbles"] || response['lost']
        @own_rec        = response["own_rec"]
        @own_rec_yards  = response["own_rec_yards"] || response["own_rec_yds"]
        @opp_rec        = response["opp_rec"]
        @opp_rec_yards  = response["opp_rec_yards"] || response["opp_rec_yds"]
        @out_of_bounds  = response["out_of_bounds"] || response['oob']
        @forced_fumbles = response["forced_fumbles"] || response['force_fum']
        @own_rec_tds    = response["own_rec_tds"] || response["own_rec_td"]
        @opp_rec_tds    = response["opp_rec_tds"] || response["opp_rec_td"]
        @ez_rec_tds     = response["ez_rec_tds"] # unknown ncaafb
      end
    end

  end
end

# ncaafb = {"fum"=>0, "lost"=>0, "oob"=>0, "own_rec"=>0, "own_rec_yds"=>0, "own_rec_td"=>0, "force_fum"=>3, "opp_rec"=>2, "opp_rec_yds"=>0, "opp_rec_td"=>0}
