require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::DivisionTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/league/hierarchy") do
      hierarchy = sr.hierarchy
      @division = hierarchy.division('D1')
    end
  end

  def test_it_initializes_an_ncaamb_division
    assert [:name, :alias].all? { |att| @division.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, @division
  end

  def test_it_has_conferences
    assert_equal 33, @division.conferences.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Conference, @division.conferences.first
  end

  def test_it_can_find_conference_by_name
    conf = @division.conference('PAC12')
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Conference, conf
    assert_equal 'PAC12', conf.alias
  end

  def test_it_can_find_team_by_name
    team = @division.conference('PAC12').team('ARIZ')
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Team, team
    assert_equal 'ARIZ', team.alias
  end

end
