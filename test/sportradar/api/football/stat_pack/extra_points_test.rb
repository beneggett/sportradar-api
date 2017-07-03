require 'test_helper'

class Sportradar::Api::Football::StatPack::ExtraPointsTest < Minitest::Test

  def setup
    @attrs = {"kicks"=>{"totals"=>{"attempts"=>3, "blocked"=>0, "made"=>2}, "players"=>[{"name"=>"Mason Crosby", "jersey"=>"02", "reference"=>"00-0025580", "id"=>"e0856548-6fd5-4f83-9aa0-91f1bf4cbbd8", "position"=>"K", "attempts"=>3, "made"=>2, "blocked"=>0}]},
 "conversions"=>{"totals"=>{"pass_attempts"=>0, "pass_successes"=>0, "rush_attempts"=>0, "rush_successes"=>0, "defense_attempts"=>0, "defense_successes"=>0, "turnover_successes"=>0}, "players"=>[]}}
  end

  def test_stat_pack_extra_points_initializes
    data_object = Sportradar::Api::Football::StatPack::ExtraPoints.new(@attrs)
    assert [:attempts, :made, :blocked].all? { |e| data_object.attributes.include?(e) }
  end


end
