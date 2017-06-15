module Sportradar
  module Api
    class Football::StatPack::Punts < Football::StatPack
      attr_accessor :avg_yards, :yards, :attempts, :blocked, :longest, :touchbacks, :inside_20, :avg_net_yards, :return_yards, :net_yards

      def set_stats
        @avg_yards     = response["avg_yards"] || response['avg']
        @yards         = response["yards"] || response['yds']
        @attempts      = response["attempts"] || response['punts']
        @blocked       = response["blocked"] || response['blk']
        @longest       = response["longest"] || response['lg']
        @touchbacks    = response["touchbacks"] || response['tb']
        @inside_20     = response["inside_20"] || response['in20']
        @avg_net_yards = response["avg_net_yards"] || response['net_avg']
        @return_yards  = response["return_yards"] || response['return_yards']
        @net_yards     = response["net_yards"] # unknown ncaafb
      end
    end

  end
end

# ncaafb = {"punts"=>3, "yds"=>94, "net_yds"=>94, "lg"=>39, "blk"=>0, "in20"=>2, "tb"=>0, "ret"=>0, "sfty"=>0, "avg"=>31.333, "net_avg"=>31.333, "ret_yds"=>0, "avg_ret"=>0.0, "in20_pct"=>66.667, "tb_pct"=>0.0}
