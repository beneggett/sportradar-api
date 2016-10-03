require 'test_helper'

class Sportradar::Api::Nfl::DepthChartTest < Minitest::Test

  def setup
    @attrs = {"position"=> [{"name"=>"$LB", "player"=> [{"name"=>"Deone Bucannon", "jersey"=>"20", "id"=>"a1902bda-47bc-4436-9165-2d79620e4030", "position"=>"ILB", "depth"=>"1"}, {"name"=>"Gabriel Martin", "jersey"=>"50", "id"=>"7595ead0-d80a-4dc5-bbd4-b2577d566608", "position"=>"ILB", "depth"=>"2"}]}, {"name"=>"FS", "player"=> [{"name"=>"Tyrann Mathieu", "jersey"=>"32", "id"=>"8c8b7d6e-6ed8-4a10-8ae9-b50300bd766b", "position"=>"FS", "depth"=>"1"}, {"name"=>"Dayario Swearinger", "jersey"=>"36", "id"=>"5486420b-b40c-4e7c-ab47-9d70b1673c3b", "position"=>"FS", "depth"=>"2"}]}]}
    @data_object = Sportradar::Api::Nfl::DepthChart.new(@attrs)
  end

  def test_nfl_depth_chart_initialization
    assert [:chart].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_depth_chart_selects_a_team_string
    assert_kind_of Hash, @data_object.team(1)
    assert_equal 2, @data_object.team(1).keys.count
  end

  def test_nfl_depth_chart_each
    # Note really sure what to test here
    @data_object.each do |key, values|
      assert_kind_of Fixnum, key
      assert_kind_of Hash, values
    end
  end

end
