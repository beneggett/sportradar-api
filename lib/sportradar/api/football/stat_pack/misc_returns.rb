module Sportradar
  module Api
    class Football::StatPack::MiscReturns < Football::StatPack
      attr_accessor :returns, :yards, :touchdowns, :blk_fg_touchdowns, :blk_punt_touchdowns, :fg_return_touchdowns, :ez_rec_touchdowns

      def set_stats
        @returns              = response["returns"] || response['number']
        @yards                = response["yards"]
        @touchdowns           = response["touchdowns"]
        @blk_fg_touchdowns    = response["blk_fg_touchdowns"]
        @blk_punt_touchdowns  = response["blk_punt_touchdowns"]
        @fg_return_touchdowns = response["fg_return_touchdowns"]
        @ez_rec_touchdowns    = response["ez_rec_touchdowns"]
      end
    end

  end
end
