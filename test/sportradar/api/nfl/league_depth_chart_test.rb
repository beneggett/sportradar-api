require 'test_helper'

class Sportradar::Api::Nfl::LeagueDepthChartTest < Minitest::Test

  def setup
    @attrs = {"season"=> {"id"=>"49037b4f-71c4-4e4d-8963-4f9b83e0b4bc", "year"=>"2016", "type"=>"REG", "name"=>"REG", "week"=> {"id"=>"fca6b835-3977-4979-8a74-4d3f46e3be24", "sequence"=>"1", "title"=>"1"}, "depth_charts"=> {"team"=> [{"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "id"=>"de760528-1dc0-416a-a978-b510d20692ff", "defense"=> {"position"=> [{"name"=>"$LB", "player"=> [{"name"=>"Deone Bucannon", "jersey"=>"20", "id"=>"a1902bda-47bc-4436-9165-2d79620e4030", "position"=>"ILB", "depth"=>"1"}, {"name"=>"Gabriel Martin", "jersey"=>"50", "id"=>"7595ead0-d80a-4dc5-bbd4-b2577d566608", "position"=>"ILB", "depth"=>"2"}]}, {"name"=>"FS", "player"=> [{"name"=>"Tyrann Mathieu", "jersey"=>"32", "id"=>"8c8b7d6e-6ed8-4a10-8ae9-b50300bd766b", "position"=>"FS", "depth"=>"1"}, {"name"=>"Dayario Swearinger", "jersey"=>"36", "id"=>"5486420b-b40c-4e7c-ab47-9d70b1673c3b", "position"=>"FS", "depth"=>"2"}]} ] } }, {"name"=>"Fake", "market"=>"Team", "alias"=>"FAK", "id"=>"fake-team-id", "defense"=> {"position"=> [{"name"=>"$LB", "player"=> [{"name"=>"Deone Bucannon", "jersey"=>"20", "id"=>"a1902bda-47bc-4436-9165-2d79620e4030", "position"=>"ILB", "depth"=>"1"}, {"name"=>"Gabriel Martin", "jersey"=>"50", "id"=>"7595ead0-d80a-4dc5-bbd4-b2577d566608", "position"=>"ILB", "depth"=>"2"}]}, {"name"=>"FS", "player"=> [{"name"=>"Tyrann Mathieu", "jersey"=>"32", "id"=>"8c8b7d6e-6ed8-4a10-8ae9-b50300bd766b", "position"=>"FS", "depth"=>"1"}]} ] } } ] } } }
    @data_object = Sportradar::Api::Nfl::LeagueDepthChart.new(@attrs)
  end

  def test_nfl_league_depth_chart_initialization
    assert [:season, :charts].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_league_depth_chart_find_by_team_id
    assert_kind_of Sportradar::Api::Nfl::TeamDepthChart,  @data_object.team('fake-team-id')
    assert_equal "Team Fake",  @data_object.team('fake-team-id').team.full_name
  end

  def test_nfl_league_depth_chart_find_by_team_abbreviation
    assert_kind_of Sportradar::Api::Nfl::TeamDepthChart,  @data_object.team(abbrev: 'FAK')
    assert_equal "Team Fake",  @data_object.team(abbrev: 'FAK').team.full_name
  end

end
