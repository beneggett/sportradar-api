module Sportradar
  module Api
    class Football::StatPack::KickReturns < Football::StatPack
      attr_accessor :returns, :yards, :avg_yards, :touchdowns, :longest, :faircatches, :longest_touchdown

      def set_stats
        @returns           = response["returns"]
        @yards             = response["yards"] || response['yds']
        @avg_yards         = response["avg_yards"] || response['avg']
        @touchdowns        = response["touchdowns"] || response['td']
        @longest           = response["longest"] || response['lg']
        @faircatches       = response["faircatches"] || response['fc']
        @longest_touchdown = response["longest_touchdown"] # unknown ncaafb
      end
    end

  end
end
# ncaafb = {"returns"=>4, "yds"=>125, "fc"=>0, "lg"=>47, "td"=>0, "avg"=>31.25, "yds_10_pls"=>0, "yds_20_pls"=>1, "yds_30_pls"=>0, "yds_40_pls"=>2, "yds_50_pls"=>0}
