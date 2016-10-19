require 'test_helper'

class Sportradar::Api::Nfl::DriveTest < Minitest::Test

  def setup
    @attrs = {"id"=>"5788169c-cf3a-4eb2-970b-1a757cfbfeed", "sequence"=>"1", "start_reason"=>"Kickoff", "end_reason"=>"Punt", "play_count"=>"4", "duration"=>"1:46", "first_downs"=>"1", "gain"=>"-1", "penalty_yards"=>"0", "play"=>[{"id"=>"e304f153-8d48-4bee-b3f7-8ced6a93d073", "sequence"=>"36.0", "reference"=>"36", "clock"=>"15:00", "home_points"=>"0", "away_points"=>"0", "type"=>"kickoff", "wall_clock"=>"2016-10-17T00:32:53+00:00", "start_situation"=>{"clock"=>"15:00", "down"=>"0", "yfd"=>"0", "possession"=>{"name"=>"Colts", "market"=>"Indianapolis", "alias"=>"IND", "reference"=>"4988", "id"=>"82cf9565-6eb9-4f01-bdbd-5aa0d472fcd9"}, "location"=>{"name"=>"Colts", "market"=>"Indianapolis", "alias"=>"IND", "reference"=>"4988", "id"=>"82cf9565-6eb9-4f01-bdbd-5aa0d472fcd9", "yardline"=>"35"}}, "end_situation"=>{"clock"=>"14:53", "down"=>"1", "yfd"=>"10", "possession"=>{"name"=>"Texans", "market"=>"Houston", "alias"=>"HOU", "reference"=>"5011", "id"=>"82d2d380-3834-4938-835f-aec541e5ece7"}, "location"=>{"name"=>"Texans", "market"=>"Houston", "alias"=>"HOU", "reference"=>"5011", "id"=>"82d2d380-3834-4938-835f-aec541e5ece7", "yardline"=>"21"}}, "description"=>"1-P.McAfee kicks 61 yards from IND 35 to HST 4. 13-B.Miller to HST 21 for 17 yards (53-E.Jackson).", "alt_description"=>"P.McAfee kicks 61 yards from IND 35 to HST 4. B.Miller to HST 21 for 17 yards (E.Jackson).", "statistics"=>{"kick"=>{"attempt"=>"1", "yards"=>"61", "team"=>{"name"=>"Colts", "market"=>"Indianapolis", "alias"=>"IND", "reference"=>"4988", "id"=>"82cf9565-6eb9-4f01-bdbd-5aa0d472fcd9"}, "player"=>{"name"=>"Pat McAfee", "jersey"=>"01", "reference"=>"00-0027145", "id"=>"25e04595-13ab-4913-90db-1111db830e84", "position"=>"P"}}, "return"=>{"return"=>"1", "yards"=>"17", "category"=>"kick_return", "team"=>{"name"=>"Texans", "market"=>"Houston", "alias"=>"HOU", "reference"=>"5011", "id"=>"82d2d380-3834-4938-835f-aec541e5ece7"}, "player"=>{"name"=>"Braxton Miller", "jersey"=>"13", "reference"=>"00-0033069", "id"=>"c678b91c-53a7-4a29-ae4e-d0bbe964069b", "position"=>"WR"}}, "defense"=>{"tackle"=>"1", "team"=>{"name"=>"Colts", "market"=>"Indianapolis", "alias"=>"IND", "reference"=>"4988", "id"=>"82cf9565-6eb9-4f01-bdbd-5aa0d472fcd9"}, "player"=>{"name"=>"Edwin Jackson", "jersey"=>"53", "reference"=>"00-0031704", "id"=>"f0437089-96b4-48af-8b71-c40c68412cdc", "position"=>"ILB"}}}}]}
  end

  def test_plays_return_empty_array_when_nil
    drive = Sportradar::Api::Nfl::Drive.new(@attrs.merge("play" => nil, "plays" => nil))
    assert_equal [], drive.plays
  end


end
