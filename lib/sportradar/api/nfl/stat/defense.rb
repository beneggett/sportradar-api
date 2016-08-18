module Sportradar
  module Api
    class Nfl::Stat::Defense < Nfl::StatPack
      def set_stats(data)
        @tackles                = data["tackles"]
        @assists                = data["assists"]
        @combined               = data["combined"]
        @sacks                  = data["sacks"]
        @sack_yards             = data["sack_yards"]
        @interceptions          = data["interceptions"]
        @passes_defended        = data["passes_defended"]
        @forced_fumbles         = data["forced_fumbles"]
        @fumble_recoveries      = data["fumble_recoveries"]
        @qb_hits                = data["qb_hits"]
        @tloss                  = data["tloss"]
        @tloss_yards            = data["tloss_yards"]
        @safeties               = data["safeties"]
        @sp_tackles             = data["sp_tackles"]
        @sp_assists             = data["sp_assists"]
        @sp_forced_fumbles      = data["sp_forced_fumbles"]
        @sp_fumble_recoveries   = data["sp_fumble_recoveries"]
        @sp_blocks              = data["sp_blocks"]
        @misc_tackles           = data["misc_tackles"]
        @misc_assists           = data["misc_assists"]
        @misc_forced_fumbles    = data["misc_forced_fumbles"]
        @misc_fumble_recoveries = data["misc_fumble_recoveries"]
        @missed_tackles         = data["missed_tackles"]
      end
    end

  end
end
