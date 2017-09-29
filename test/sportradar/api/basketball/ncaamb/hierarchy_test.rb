require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::HierarchyTest < Minitest::Test

  def setup
    @ncaamb = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/#{@ncaamb.api.content_format}/league/hierarchy") do
      @ncaamb.get_hierarchy
    end
  end

  def test_it_initializes_an_ncaamb_hierarchy
    assert [:name, :alias].all? { |att| @ncaamb.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb, @ncaamb
  end

  def test_it_has_divisions
    assert_equal 9, @ncaamb.divisions.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, @ncaamb.divisions.first
  end

  def test_it_can_find_division_by_name
    div = @ncaamb.division('D1')
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, div
    assert_equal 'D1', div.alias
  end

  def test_it_has_conferences
    assert_equal 147, @ncaamb.conferences.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Conference, @ncaamb.conferences.first
  end

  def test_it_has_teams
    assert_equal 1055, @ncaamb.teams.size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Team, @ncaamb.teams.first
  end

  def test_d1_teams_have_venues
    assert @ncaamb.division('D1').teams.all?(&:venue)
    assert_instance_of Sportradar::Api::Basketball::Venue, @ncaamb.division('D1').teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name alias market full_name]
    assert @ncaamb.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
