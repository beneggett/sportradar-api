require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::HierarchyTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/#{sr.content_format}/league/hierarchy") do
      @hierarchy = sr.hierarchy
    end
  end

  def test_it_initializes_an_ncaamb_hierarchy
    assert [:name, :alias].all? { |att| @hierarchy.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Hierarchy, @hierarchy
  end

  def test_it_has_divisions
    assert_equal 9, @hierarchy.divisions.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, @hierarchy.divisions.first
  end

  def test_it_can_find_division_by_name
    div = @hierarchy.division('D1')
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, div
    assert_equal 'D1', div.alias
  end

  def test_it_has_conferences
    assert_equal 147, @hierarchy.conferences.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Conference, @hierarchy.conferences.first
  end

  def test_it_has_teams
    assert_equal 1055, @hierarchy.teams.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Team, @hierarchy.teams.first
  end

  def test_d1_teams_have_venues
    assert @hierarchy.division('D1').teams.all?(&:venue)
    assert_instance_of Sportradar::Api::Basketball::Venue, @hierarchy.division('D1').teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name alias market full_name]
    assert @hierarchy.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
