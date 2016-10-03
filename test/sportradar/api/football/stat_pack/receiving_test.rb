require 'test_helper'

class Sportradar::Api::Football::StatPack::ReceivingTest < Minitest::Test

  def setup
    @attrs = {"targets"=>"31", "receptions"=>"21", "avg_yards"=>"9.333", "yards"=>"196", "touchdowns"=>"1", "yards_after_catch"=>"64", "longest"=>"25", "longest_touchdown"=>"4", "redzone_targets"=>"3", "air_yards"=>"132", "player"=> [{"name"=>"DeSean Jackson", "jersey"=>"11", "reference"=>"00-0026189", "id"=>"3e618eb6-41f2-4f20-ad70-2460f9366f43", "position"=>"WR", "receptions"=>"0", "targets"=>"1", "yards"=>"0", "avg_yards"=>"0.0", "longest"=>"0", "touchdowns"=>"0", "longest_touchdown"=>"0", "yards_after_catch"=>"0", "redzone_targets"=>"0", "air_yards"=>"0"} ] }
  end

  def test_stat_pack_receiving_initializes
    data_object = Sportradar::Api::Football::StatPack::Receiving.new(@attrs)
    assert [:longest].all? { |e| data_object.attributes.include?(e) }
  end


end
