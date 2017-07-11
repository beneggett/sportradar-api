module Sportradar
  module Api
    class Football::StatPack::Defense < Football::StatPack
      attr_accessor :tackles, :assists, :combined, :sacks, :sack_yards, :interceptions, :passes_defended, :forced_fumbles, :fumble_recoveries, :qb_hits, :tloss, :tloss_yards, :safeties, :sp_tackles, :sp_assists, :sp_forced_fumbles, :sp_fumble_recoveries, :sp_blocks, :misc_tackles, :misc_assists, :misc_forced_fumbles, :misc_fumble_recoveries, :missed_tackles

      def set_stats
        @tackles                = response["tackles"] || response["tackle"]
        @assists                = response["assists"] || response['ast']
        @combined               = response["combined"] || response['comb']
        @sacks                  = response["sacks"] || response['sack']
        @sack_yards             = response["sack_yards"] || response['sack_yds']
        @interceptions          = response["interceptions"] || response['int']
        @passes_defended        = response["passes_defended"] || response['pd']
        @forced_fumbles         = response["forced_fumbles"] || response['force_fum']
        @fumble_recoveries      = response["fumble_recoveries"] || response['fum_rec']
        @qb_hits                = response["qb_hits"] || response['qh']
        @tloss                  = response["tloss"] || response['tlost']
        @tloss_yards            = response["tloss_yards"]
        @safeties               = response["safeties"] || response['sfty']
        @sp_tackles             = response["sp_tackles"] || response['sp_tackle']
        @sp_assists             = response["sp_assists"] || response['sp_ast']
        @sp_forced_fumbles      = response["sp_forced_fumbles"] || response['sp_force_fum']
        @sp_fumble_recoveries   = response["sp_fumble_recoveries"] || response['sp_fum_rec']
        @sp_blocks              = response["sp_blocks"]
        @misc_tackles           = response["misc_tackles"] || response['misc_tackle']
        @misc_assists           = response["misc_assists"] || response['misc_ast']
        @misc_forced_fumbles    = response["misc_forced_fumbles"] || response['misc_force_fum']
        @misc_fumble_recoveries = response["misc_fumble_recoveries"] || response['misc_fum_rec']
        @missed_tackles         = response["missed_tackles"]
      end
    end

  end
end
