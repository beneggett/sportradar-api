module Sportradar
  module Api
    class Football::StatPack::ExtraPoints < Football::StatPack
      attr_accessor :attempts, :pct, :made, :blocked, :pass_attempts, :pass_successes, :rush_attempts, :rush_successes, :defense_attempts, :defense_successes, :turnover_successes

      def set_stats
        kick_data = response['kicks'] || response
        @attempts = kick_data["attempts"] || kick_data["att"]
        @made     = kick_data["made"]
        @blocked  = kick_data["blocked"] || kick_data["blk"]
        @pct      = kick_data["pct"] ||  || (@made.to_f / @attempts.to_i)
        if response['conversions']
          @pass_attempts      = response["pass_attempts"]
          @pass_successes     = response["pass_successes"]
          @rush_attempts      = response["rush_attempts"]
          @rush_successes     = response["rush_successes"]
          @defense_attempts   = response["defense_attempts"]
          @defense_successes  = response["defense_successes"]
          @turnover_successes = response["turnover_successes"]
        end
      end

    end
  end
end

# # sample response
# extra_points =
#   {"kicks"=>
#     {"player"=>
#       [
#        {"name"=>"Aldrick Rosas",
#         "jersey"=>"03",
#         "reference"=>"00-0032870",
#         "id"=>"8fb2ca06-3d13-4552-98e0-7b913b4ab5b9",
#         "position"=>"K",
#         "attempts"=>"1",
#         "made"=>"1",
#         "blocked"=>"0"}],
#      "attempts"=>"3",
#      "blocked"=>"0",
#      "made"=>"3"},
#   "conversions"=> {
#     "pass_attempts"=>"0",
#     "pass_successes"=>"0",
#     "rush_attempts"=>"0",
#     "rush_successes"=>"0",
#     "defense_attempts"=>"0",
#     "defense_successes"=>"0",
#     "turnover_successes"=>"0"
#     }
#   }
