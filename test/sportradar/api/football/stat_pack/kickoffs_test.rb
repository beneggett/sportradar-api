require 'test_helper'

class Sportradar::Api::Football::StatPack::KickoffsTest < Minitest::Test

  def setup
    @attrs = {"kickoffs"=>"3", "endzone"=>"1", "inside_20"=>"0", "return_yards"=>"54", "touchbacks"=>"1", "yards"=>"201", "out_of_bounds"=>"0", "player"=> {"name"=>"Kai Forbath", "jersey"=>"02", "reference"=>"00-0028787", "id"=>"5514afb6-bd43-49a8-9bf7-b8baaaecdabe", "position"=>"K", "kickoffs"=>"3", "endzone"=>"1", "inside_20"=>"0", "return_yards"=>"54", "touchbacks"=>"1", "yards"=>"201", "out_of_bounds"=>"0"}}
  end

  def test_stat_pack_kickoffs_initializes
    data_object = Sportradar::Api::Football::StatPack::Kickoffs.new(@attrs)
    assert [:kickoffs, :endzone].all? { |e| data_object.attributes.include?(e) }
  end


end
