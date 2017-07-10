require 'test_helper'

class Sportradar::Api::Football::NflTest < Minitest::Test

  def setup
    @nfl = Sportradar::Api::Football::Nfl.new
    VCR.use_cassette("nfl/league") do
      @nfl.get_hierarchy
      @nfl.get_schedule
      @nfl.get_standings
    end
  end

  def test_it_has_conferences
    assert_equal 2, @nfl.conferences.size
    assert_instance_of Sportradar::Api::Football::Nfl::Conference, @nfl.conferences.first
  end

  def test_it_has_divisions
    assert_equal 8, @nfl.divisions.size
    assert_instance_of Sportradar::Api::Football::Nfl::Division, @nfl.divisions.first
  end

  def test_it_has_teams
    assert_equal 32, @nfl.teams.size
    assert_instance_of Sportradar::Api::Football::Nfl::Team, @nfl.teams.first
  end

  def test_it_has_games
    assert_equal 256, @nfl.games.size
    assert_instance_of Sportradar::Api::Football::Nfl::Game, @nfl.games.first
  end

  def test_it_has_weeks
    assert_equal 17, @nfl.weeks.size
    assert_instance_of Sportradar::Api::Football::Nfl::Week, @nfl.weeks.first
  end

  def test_teams_have_venues
    assert_instance_of Sportradar::Api::Football::Venue, @nfl.teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name alias market full_name]
    assert @nfl.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
