require 'test_helper'

class Sportradar::Api::Football::StatPack::MiscReturnsTest < Minitest::Test

  def setup
    @attrs = {"returns"=>"0", "yards"=>"0", "touchdowns"=>"0", "blk_fg_touchdowns"=>"0", "blk_punt_touchdowns"=>"0", "fg_return_touchdowns"=>"0", "ez_rec_touchdowns"=>"0", "__content__"=>"\n    "}
  end

  def test_stat_pack_misc_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::MiscReturns.new(@attrs)
    assert [:returns].all? { |e| data_object.attributes.include?(e) }
  end


end
