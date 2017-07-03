require 'test_helper'

class Sportradar::Api::Football::StatPack::PuntsTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"attempts"=>1, "yards"=>46, "net_yards"=>46, "blocked"=>0, "touchbacks"=>0, "inside_20"=>0, "return_yards"=>0, "avg_net_yards"=>46.0, "avg_yards"=>46.0, "longest"=>46},
 "players"=>
  [{"name"=>"Jacob Schum",
    "jersey"=>"10",
    "reference"=>"00-0029739",
    "id"=>"cdfb58eb-2920-47d4-9c24-df5de536450e",
    "position"=>"P",
    "attempts"=>1,
    "yards"=>46,
    "avg_yards"=>46.0,
    "blocked"=>0,
    "longest"=>46,
    "touchbacks"=>0,
    "inside_20"=>0,
    "avg_net_yards"=>46.0,
    "return_yards"=>0,
    "net_yards"=>46}]}
  end

  def test_stat_pack_punts_initializes
    data_object = Sportradar::Api::Football::StatPack::Punts.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
