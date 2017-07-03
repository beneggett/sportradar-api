require 'test_helper'

class Sportradar::Api::Football::StatPack::KickoffsTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"endzone"=>0, "inside_20"=>1, "return_yards"=>28, "touchbacks"=>4, "yards"=>380, "out_of_bounds"=>0, "number"=>6},
 "players"=>[{"name"=>"Mason Crosby", "jersey"=>"02", "reference"=>"00-0025580", "id"=>"e0856548-6fd5-4f83-9aa0-91f1bf4cbbd8", "position"=>"K", "endzone"=>0, "inside_20"=>1, "return_yards"=>28, "touchbacks"=>4, "yards"=>380, "out_of_bounds"=>0, "number"=>6}]}
  end

  def test_stat_pack_kickoffs_initializes
    data_object = Sportradar::Api::Football::StatPack::Kickoffs.new(@attrs)
    assert [:kickoffs, :endzone].all? { |e| data_object.attributes.include?(e) }
  end


end
