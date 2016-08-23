module Sportradar
  module Api
    class Football::StatPack::Rushing < Football::StatPack
      attr_accessor :avg_yards, :yards, :touchdowns, :longest, :longest_touchdown, :attempts, :tlost, :tlost_yards, :redzone_attempts

      def set_stats
        @avg_yards         = response["avg_yards"]
        @yards             = response["yards"]
        @touchdowns        = response["touchdowns"]
        @longest           = response["longest"]
        @longest_touchdown = response["longest_touchdown"]
        @attempts          = response["attempts"]
        @tlost             = response["tlost"]
        @tlost_yards       = response["tlost_yards"]
        @redzone_attempts  = response["redzone_attempts"]
      end
    end
    
  end
end
