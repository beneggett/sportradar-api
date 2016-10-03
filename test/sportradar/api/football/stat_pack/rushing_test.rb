require 'test_helper'

class Sportradar::Api::Football::StatPack::RushingTest < Minitest::Test

  def setup
    @attrs = {"avg_yards"=>"4.4", "attempts"=>"37", "touchdowns"=>"0", "tlost"=>"3", "tlost_yards"=>"-6", "yards"=>"161", "longest"=>"14", "longest_touchdown"=>"0", "redzone_attempts"=>"2", "player"=> [{"name"=>"Jamison Crowder", "jersey"=>"80", "reference"=>"00-0031941", "id"=>"8002dd5e-a75a-4d72-9a8c-0f4dbc80d459", "position"=>"WR", "avg_yards"=>"2.0", "attempts"=>"1", "touchdowns"=>"0", "yards"=>"2", "longest"=>"2", "longest_touchdown"=>"0", "redzone_attempts"=>"0", "tlost"=>"0", "tlost_yards"=>"0"} ] }
  end

  def test_stat_pack_rushing_initializes
    data_object = Sportradar::Api::Football::StatPack::Rushing.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
