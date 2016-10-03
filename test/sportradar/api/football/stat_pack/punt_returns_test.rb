require 'test_helper'

class Sportradar::Api::Football::StatPack::PuntReturnsTest < Minitest::Test

  def setup
    @attrs =  {"avg_yards"=>"11.5", "returns"=>"2", "yards"=>"23", "longest"=>"13", "touchdowns"=>"0", "longest_touchdown"=>"0", "faircatches"=>"1", "player"=> {"name"=>"Jamison Crowder", "jersey"=>"80", "reference"=>"00-0031941", "id"=>"8002dd5e-a75a-4d72-9a8c-0f4dbc80d459", "position"=>"WR", "returns"=>"2", "yards"=>"23", "avg_yards"=>"11.5", "touchdowns"=>"0", "longest"=>"13", "faircatches"=>"1", "longest_touchdown"=>"0"}}
  end

  def test_stat_pack_punt_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::PuntReturns.new(@attrs)
    assert [:longest].all? { |e| data_object.attributes.include?(e) }
  end


end
