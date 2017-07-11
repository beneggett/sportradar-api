module Sportradar
  module Api
    class Football::StatPack::PuntReturns < Football::StatPack
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
# ncaafb = {"returns"=>2, "yds"=>1, "fc"=>1, "lg"=>1, "td"=>0, "avg"=>0.5, "yds_10_pls"=>0, "yds_20_pls"=>0, "yds_30_pls"=>0, "yds_40_pls"=>0, "yds_50_pls"=>0}
