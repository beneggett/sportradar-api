require 'test_helper'

class Sportradar::Api::Football::StatPack::IntReturnsTest < Minitest::Test

  def setup
    @attrs =  {"avg_yards"=>"0.0", "returns"=>"0", "yards"=>"0", "touchdowns"=>"0", "__content__"=>"\n    "}
  end

  def test_stat_pack_int_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::IntReturns.new(@attrs)
    assert [:avg_yards, :yards].all? { |e| data_object.attributes.include?(e) }
  end


end
