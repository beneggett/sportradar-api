module Sportradar
  module Api
    class Football::StatPack::Rushing < Football::StatPack
      attr_accessor :avg_yards, :yards, :touchdowns, :longest, :longest_touchdown, :attempts, :tlost, :tlost_yards, :redzone_attempts

      def set_stats
        @avg_yards         = response["avg_yards"] || response['avg']
        @yards             = response["yards"] || response['yds']
        @touchdowns        = response["touchdowns"] || response['td']
        @longest           = response["longest"] || response['lg']
        @longest_touchdown = response["longest_touchdown"] # unknown ncaafb
        @attempts          = response["attempts"] || response['att']
        @tlost             = response["tlost"] # unknown ncaafb
        @tlost_yards       = response["tlost_yards"] # unknown ncaafb
        @redzone_attempts  = response["redzone_attempts"] || response['rz_att']
      end
    end

  end
end

# ncaafb = {"att"=>35, "yds"=>189, "avg"=>5.4, "lg"=>40, "td"=>2, "fd"=>11, "fd_pct"=>31.429, "sfty"=>0, "rz_att"=>8, "fum"=>0, "yds_10_pls"=>1, "yds_20_pls"=>1, "yds_30_pls"=>1, "yds_40_pls"=>1, "yds_50_pls"=>0}
