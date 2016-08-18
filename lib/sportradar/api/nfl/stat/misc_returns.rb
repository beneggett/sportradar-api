module Sportradar
  module Api
    class Nfl::Stat::MiscReturns < Nfl::StatPack
      def set_stats(data)
        @returns              = data["returns"]
        @yards                = data["yards"]
        @touchdowns           = data["touchdowns"]
        @blk_fg_touchdowns    = data["blk_fg_touchdowns"]
        @blk_punt_touchdowns  = data["blk_punt_touchdowns"]
        @fg_return_touchdowns = data["fg_return_touchdowns"]
        @ez_rec_touchdowns    = data["ez_rec_touchdowns"]
      end
    end

  end
end
