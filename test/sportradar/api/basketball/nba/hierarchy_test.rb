require 'test_helper'

class Sportradar::Api::Basketball::Nba::HierarchyTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/league/hierarchy") do
      @hierarchy = sr.league_hierarchy
    end
  end

  def test_it_initializes_an_nba_hierarchy
    assert [:name, :alias].all? { |e| @hierarchy.attributes.include?(e) }
  end

  def test_it_has_conferences
    assert_equal 2, @hierarchy.conferences.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Conference, @hierarchy.conferences.first
  end

  def test_it_has_divisions
    assert_equal 6, @hierarchy.divisions.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Division, @hierarchy.divisions.first
  end

  def test_it_has_teams
    assert_equal 30, @hierarchy.teams.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Team, @hierarchy.teams.first
  end

  def test_teams_have_venues
    assert_instance_of Sportradar::Api::Basketball::Venue, @hierarchy.teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name alias market full_name]
    assert @hierarchy.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
