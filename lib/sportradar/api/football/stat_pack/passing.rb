module Sportradar
  module Api
    class Football::StatPack::Passing < Football::StatPack
      attr_accessor :attempts, :completions, :cmp_pct, :yards, :avg_yards, :sacks, :sack_yards, :touchdowns, :longest, :interceptions, :rating, :longest_touchdown, :air_yards, :net_yards, :redzone_attempts

      def set_stats
        @attempts          = response["attempts"]         || response['att']
        @completions       = response["completions"]      || response['cmp']
        @cmp_pct           = response["cmp_pct"]
        # 'yards' is air yards, which does not include sack yardage. air_yards is for college, net_yards for NFL
        @yards             = response["yards"]            || response['yds']
        @avg_yards         = response["avg_yards"]        || response['avg']
        @sacks             = response["sacks"]            || response['sk']
        @sack_yards        = response["sack_yards"]       || response['sk_yds']
        @touchdowns        = response["touchdowns"]       || response['td']
        @longest           = response["longest"]          || response['lg']
        @interceptions     = response["interceptions"]    || response['int']
        @rating            = response["rating"]
        @longest_touchdown = response["longest_touchdown"]
        @air_yards         = response["air_yards"]
        # passing net_yards is the correct measure for team stats, as it includes sack yardage
        @net_yards         = response["net_yards"]
        @redzone_attempts  = response["redzone_attempts"] || response['rz_att']
      end
    end

  end
end
