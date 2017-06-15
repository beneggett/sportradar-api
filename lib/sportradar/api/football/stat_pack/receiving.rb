module Sportradar
  module Api
    class Football::StatPack::Receiving < Football::StatPack
      attr_accessor :avg_yards, :yards, :touchdowns, :longest, :longest_touchdown, :targets, :receptions, :yards_after_catch, :redzone_targets, :air_yards

      def set_stats
        @yards             = response["yards"] || response['yds']
        @touchdowns        = response["touchdowns"] || response['td']
        @longest           = response["longest"] || response['lg']
        @longest_touchdown = response["longest_touchdown"]
        @targets           = response["targets"] || response['tar']
        @receptions        = response["receptions"] || response['rec']
        @yards_after_catch = response["yards_after_catch"] || response['yac']
        @redzone_targets   = response["redzone_targets"] || response['rz_tar']
        @air_yards         = response["air_yards"] # unknown ncaafb
        @avg_yards         = response["avg_yards"] || (@yards.to_f / @receptions.to_i)
      end
    end

  end
end
# ncaafb = {"tar"=>54, "rec"=>38, "yds"=>441, "yac"=>441, "fd"=>19, "avg"=>11.605, "td"=>4, "lg"=>34, "rz_tar"=>8, "fum"=>0, "yds_10_pls"=>9, "yds_20_pls"=>3, "yds_30_pls"=>3, "yds_40_pls"=>0, "yds_50_pls"=>0}
