require 'test_helper'

class Sportradar::Api::Football::StatPack::MiscReturnsTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"yards"=>0, "touchdowns"=>0, "blk_fg_touchdowns"=>0, "blk_punt_touchdowns"=>0, "fg_return_touchdowns"=>0, "ez_rec_touchdowns"=>0, "number"=>0}, "players"=>[]}
  end

  def test_stat_pack_misc_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::MiscReturns.new(@attrs)
    assert [:returns].all? { |e| data_object.attributes.include?(e) }
  end


end
