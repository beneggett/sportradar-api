require 'test_helper'

class Sportradar::Api::Hockey::NhlTest < Minitest::Test

  def setup
    @nhl = Sportradar::Api::Hockey::Nhl.new
  end

  def test_it_initializes_an_nhl_hierarchy
    # assert [:name, :alias].all? { |att| @nhl.send(att) }
    assert_instance_of Sportradar::Api::Hockey::Nhl, @nhl
  end

  def test_it_has_conferences
    VCR.use_cassette("nhl/hierarchy") do
      @nhl.get_hierarchy
      assert_equal 2, @nhl.conferences.size
      assert_instance_of Sportradar::Api::Hockey::Nhl::Conference, @nhl.conferences.first
    end
  end

  def test_it_has_divisions
    VCR.use_cassette("nhl/hierarchy") do
      @nhl.get_hierarchy
      assert_equal 4, @nhl.divisions.size
      assert_instance_of Sportradar::Api::Hockey::Nhl::Division, @nhl.divisions.first
    end
  end

  def test_it_has_teams
    VCR.use_cassette("nhl/hierarchy") do
      @nhl.get_hierarchy
      assert_equal 31, @nhl.teams.size
      assert_instance_of Sportradar::Api::Hockey::Team, @nhl.teams.first
    end
  end

  def test_teams_have_venues
    attributes = %i[id name city state]
    VCR.use_cassette("nhl/hierarchy") do
      @nhl.get_hierarchy
      assert_instance_of Sportradar::Api::Hockey::Venue, @nhl.teams.first.venue
      assert @nhl.teams.all? { |team| attributes.all? { |att| team.venue.send(att)} }
    end
  end

  def test_teams_have_required_attributes_from_hierarchy
    attributes = %i[id name alias market full_name]
    VCR.use_cassette("nhl/hierarchy") do
      @nhl.get_hierarchy
      assert @nhl.teams.all? { |team| attributes.all? { |att| team.send(att)} }
    end
  end

  def test_it_has_schedule_with_games
    skip 'nhl games not implemented yet'
    VCR.use_cassette("nhl/schedule") do
      assert_equal 0, @nhl.games.count
      @nhl.get_schedule
      assert_respond_to @nhl.schedule, :games
      assert_equal 41*31, @nhl.games.reject(&:cancelled?).size # 30 teams * 81 home games
    end
  end

  def test_it_has_retrieves_standings
    attributes = %i[wins losses overtime_losses win_pct points]
    year = 2016
    @nhl = Sportradar::Api::Hockey::Nhl.new(year: year)
    VCR.use_cassette("nhl/standings-#{year}") do
      assert_equal 0, @nhl.teams.count
      @nhl.get_standings
      assert_equal 30, @nhl.teams.count # using standings from before Vegas Golden Knights
      assert @nhl.teams.all? { |team| attributes.all? { |att| team.record.send(att)} }
    end
  end

end
