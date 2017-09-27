require 'test_helper'

class Sportradar::Api::Basketball::Nba::HierarchyTest < Minitest::Test

  def setup
    @nba = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/#{@nba.api.content_format}/league/hierarchy") do
      @nba.get_hierarchy
    end
  end

  def test_it_initializes_an_nba_hierarchy
    assert [:name, :alias].all? { |att| @nba.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Nba, @nba
  end

  def test_it_has_conferences
    assert_equal 2, @nba.conferences.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Conference, @nba.conferences.first
  end

  def test_it_has_divisions
    assert_equal 6, @nba.divisions.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Division, @nba.divisions.first
  end

  def test_it_has_teams
    assert_equal 30, @nba.teams.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Team, @nba.teams.first
  end

  def test_teams_have_venues
    assert_instance_of Sportradar::Api::Basketball::Venue, @nba.teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name alias market full_name]
    assert @nba.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
