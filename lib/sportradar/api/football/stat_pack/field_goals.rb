module Sportradar
  module Api
    class Football::StatPack::FieldGoals < Football::StatPack
      attr_accessor :attempts, :pct, :made, :blocked, :yards, :avg_yards, :longest

      def set_stats
        @attempts  = response["attempts"] || response["att"]
        @made      = response["made"]
        @blocked   = response["blocked"] || response['blk']
        @yards     = response["yards"] || response['yds']
        @avg_yards = response["avg_yards"]
        @longest   = response["longest"] || response['lg']
        @pct       = response["pct"] || (@made.to_f / @attempts.to_i)
      end
    end

  end
end
