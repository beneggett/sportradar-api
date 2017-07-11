require 'test_helper'

class Sportradar::Api::Football::StatPack::KickReturnsTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"avg_yards"=>17.5, "yards"=>35, "longest"=>18, "touchdowns"=>0, "longest_touchdown"=>0, "faircatches"=>0, "number"=>2},
 "players"=>
  [{"name"=>"Knile Davis", "jersey"=>"30", "reference"=>"00-0030280", "id"=>"a0e27c0c-0b7e-4da4-b228-1a366b09596e", "position"=>"RB", "yards"=>18, "avg_yards"=>18.0, "touchdowns"=>0, "longest"=>18, "faircatches"=>0, "longest_touchdown"=>0, "number"=>1},
   {"name"=>"Jeff Janis", "jersey"=>"83", "reference"=>"00-0031001", "id"=>"7b1c1855-fc6d-42aa-ac3e-588e82333146", "position"=>"WR", "yards"=>17, "avg_yards"=>17.0, "touchdowns"=>0, "longest"=>17, "faircatches"=>0, "longest_touchdown"=>0, "number"=>1}]}
  end

  def test_stat_pack_kick_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::KickReturns.new(@attrs)
    assert [:returns, :yards, :longest].all? { |e| data_object.attributes.include?(e) }
  end


end
