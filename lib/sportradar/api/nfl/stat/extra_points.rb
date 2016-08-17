module Sportradar
  module Api
    class Nfl::Stat::ExtraPoints < Nfl::StatPack
      def set_stats(data)
        kick_data = data['kicks'] || data
        @attempts = kick_data["attempts"]
        @made     = kick_data["made"]
        @blocked  = kick_data["blocked"]
        if data['conversions']
          @pass_attempts      = data["pass_attempts"]
          @pass_successes     = data["pass_successes"]
          @rush_attempts      = data["rush_attempts"]
          @rush_successes     = data["rush_successes"]
          @defense_attempts   = data["defense_attempts"]
          @defense_successes  = data["defense_successes"]
          @turnover_successes = data["turnover_successes"]
        end
      end

    end
  end
end

extra_points = 
  {"kicks"=>
    {"player"=>
      [
       {"name"=>"Aldrick Rosas",
        "jersey"=>"03",
        "reference"=>"00-0032870",
        "id"=>"8fb2ca06-3d13-4552-98e0-7b913b4ab5b9",
        "position"=>"K",
        "attempts"=>"1",
        "made"=>"1",
        "blocked"=>"0"}],
     "attempts"=>"3",
     "blocked"=>"0",
     "made"=>"3"},
  "conversions"=> {
    "pass_attempts"=>"0",
    "pass_successes"=>"0",
    "rush_attempts"=>"0",
    "rush_successes"=>"0",
    "defense_attempts"=>"0",
    "defense_successes"=>"0",
    "turnover_successes"=>"0"
    }
  }
