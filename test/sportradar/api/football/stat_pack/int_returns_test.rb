require 'test_helper'

class Sportradar::Api::Football::StatPack::IntReturnsTest < Minitest::Test

  def setup
    @attrs =  {"totals"=>{"avg_yards"=>2.0, "yards"=>4, "longest"=>4, "touchdowns"=>0, "longest_touchdown"=>0, "number"=>2},
 "players"=>
  [{"name"=>"Blake Martinez", "jersey"=>"50", "reference"=>"00-0032408", "id"=>"0392b852-2783-4ce4-ad39-dc8661a5be3d", "position"=>"LB", "yards"=>4, "avg_yards"=>4.0, "touchdowns"=>0, "longest"=>4, "longest_touchdown"=>0, "number"=>1},
   {"name"=>"Nick Perry", "jersey"=>"53", "reference"=>"00-0029408", "id"=>"204e0eb0-c5ef-4522-9056-393e2e5177ea", "position"=>"LB", "yards"=>0, "avg_yards"=>0.0, "touchdowns"=>0, "longest"=>0, "longest_touchdown"=>0, "number"=>1}]}
  end

  def test_stat_pack_int_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::IntReturns.new(@attrs)
    assert [:avg_yards, :yards].all? { |e| data_object.attributes.include?(e) }
  end


end
