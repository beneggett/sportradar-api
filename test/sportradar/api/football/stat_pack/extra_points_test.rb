require 'test_helper'

class Sportradar::Api::Football::StatPack::ExtraPointsTest < Minitest::Test

  def setup
    @attrs = {"kicks"=> {"attempts"=>"1", "blocked"=>"0", "made"=>"1", "player"=> {"name"=>"Kai Forbath", "jersey"=>"02", "reference"=>"00-0028787", "id"=>"5514afb6-bd43-49a8-9bf7-b8baaaecdabe", "position"=>"K", "attempts"=>"1", "made"=>"1", "blocked"=>"0"}}, "conversions"=> {"pass_attempts"=>"0", "pass_successes"=>"0", "rush_attempts"=>"0", "rush_successes"=>"0", "defense_attempts"=>"0", "defense_successes"=>"0", "turnover_successes"=>"0", "__content__"=>"\n      "}}
  end

  def test_stat_pack_extra_points_initializes
    data_object = Sportradar::Api::Football::StatPack::ExtraPoints.new(@attrs)
    assert [:attempts, :made, :blocked].all? { |e| data_object.attributes.include?(e) }
  end


end
