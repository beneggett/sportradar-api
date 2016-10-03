module Sportradar
  module Api
    class Football::StatPack::Defense < Football::StatPack
      attr_accessor :tackles, :assists, :combined, :sacks, :sack_yards, :interceptions, :passes_defended, :forced_fumbles, :fumble_recoveries, :qb_hits, :tloss, :tloss_yards, :safeties, :sp_tackles, :sp_assists, :sp_forced_fumbles, :sp_fumble_recoveries, :sp_blocks, :misc_tackles, :misc_assists, :misc_forced_fumbles, :misc_fumble_recoveries, :missed_tackles

      def set_stats
        @tackles                = response["tackles"]
        @assists                = response["assists"]
        @combined               = response["combined"]
        @sacks                  = response["sacks"]
        @sack_yards             = response["sack_yards"]
        @interceptions          = response["interceptions"]
        @passes_defended        = response["passes_defended"]
        @forced_fumbles         = response["forced_fumbles"]
        @fumble_recoveries      = response["fumble_recoveries"]
        @qb_hits                = response["qb_hits"]
        @tloss                  = response["tloss"]
        @tloss_yards            = response["tloss_yards"]
        @safeties               = response["safeties"]
        @sp_tackles             = response["sp_tackles"]
        @sp_assists             = response["sp_assists"]
        @sp_forced_fumbles      = response["sp_forced_fumbles"]
        @sp_fumble_recoveries   = response["sp_fumble_recoveries"]
        @sp_blocks              = response["sp_blocks"]
        @misc_tackles           = response["misc_tackles"]
        @misc_assists           = response["misc_assists"]
        @misc_forced_fumbles    = response["misc_forced_fumbles"]
        @misc_fumble_recoveries = response["misc_fumble_recoveries"]
        @missed_tackles         = response["missed_tackles"]
      end
    end

  end
end
