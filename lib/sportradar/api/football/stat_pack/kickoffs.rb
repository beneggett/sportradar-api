module Sportradar
  module Api
    class Football::StatPack::Kickoffs < Football::StatPack
      attr_accessor :kickoffs, :endzone, :inside_20, :return_yards, :touchbacks, :yards, :out_of_bounds

      def set_stats
        @kickoffs      = response["kickoffs"] || response['kicks']
        @endzone       = response["endzone"]
        @inside_20     = response["inside_20"] || response['in20']
        @return_yards  = response["return_yards"] || response['ret_yds']
        @touchbacks    = response["touchbacks"] || response['tb']
        @yards         = response["yards"] || response['yds']
        @average       = response['avg'] || (@yards.to_f / @kickoffs.to_i)
        @out_of_bounds = response["out_of_bounds"] # unknown ncaafb
      end
    end

  end
end
# ncaafb = {"kicks"=>10, "yds"=>606, "net_yds"=>411, "lg"=>65, "endzone"=>3, "in20"=>3, "tb"=>2, "ret"=>7, "avg"=>60.6, "net_avg"=>41.1, "ret_yds"=>195, "avg_ret"=>27.857, "in20_pct"=>30.0, "tb_pct"=>20.0}
