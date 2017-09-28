require 'test_helper'

class Sportradar::Api::Baseball::Mlb::HierarchyTest < Minitest::Test

  def setup
    @mlb = Sportradar::Api::Baseball::Mlb.new
  end

  def test_it_initializes_an_mlb_hierarchy
    # assert [:name, :alias].all? { |att| @mlb.send(att) }
    assert_instance_of Sportradar::Api::Baseball::Mlb, @mlb
  end

  def test_it_has_leagues
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/hierarchy") do
      @mlb.get_hierarchy
      assert_equal 2, @mlb.leagues.size
      assert_instance_of Sportradar::Api::Baseball::Mlb::League, @mlb.leagues.first
    end
  end

  def test_it_has_divisions
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/hierarchy") do
      @mlb.get_hierarchy
      assert_equal 6, @mlb.divisions.size
      assert_instance_of Sportradar::Api::Baseball::Mlb::Division, @mlb.divisions.first
    end
  end

  def test_it_has_teams
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/hierarchy") do
      @mlb.get_hierarchy
      assert_equal 30, @mlb.teams.size
      assert_instance_of Sportradar::Api::Baseball::Team, @mlb.teams.first
    end
  end

  def test_teams_have_venues
    attributes = %i[id name city state]
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/hierarchy") do
      @mlb.get_hierarchy
      assert_instance_of Sportradar::Api::Baseball::Venue, @mlb.teams.first.venue
      assert @mlb.teams.all? { |team| attributes.all? { |att| team.venue.send(att)} }
    end
  end

  def test_teams_have_required_attributes_from_hierarchy
    attributes = %i[id name alias market full_name]
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/hierarchy") do
      @mlb.get_hierarchy
      assert @mlb.teams.all? { |team| attributes.all? { |att| team.send(att)} }
    end
  end

  def test_it_has_schedule_with_games
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/schedule") do
      assert_equal 0, @mlb.games.count
      @mlb.schedule
      assert_respond_to @mlb.schedule, :games
      assert_equal 81*30, @mlb.games.reject(&:cancelled?).size # 30 teams * 81 home games
    end
  end

  def test_it_has_retrieves_standings
    attributes = %i[wins losses win_pct games_back]
    VCR.use_cassette("mlb/#{@mlb.api.content_format}/hierarchy/standings") do
      assert_equal 0, @mlb.teams.count
      @mlb.standings
      assert_equal 30, @mlb.teams.count
      assert @mlb.teams.all? { |team| attributes.all? { |att| team.record.send(att)} }
    end
  end

end
