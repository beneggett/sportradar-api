require 'test_helper'

class Sportradar::Api::Football::NflTest < Minitest::Test

  def setup
    @nfl = Sportradar::Api::Football::Nfl.new
  end

  def test_it_has_conferences
    VCR.use_cassette("nfl/league/hierarchy") do
      @nfl.get_hierarchy
    end
    assert_equal 2, @nfl.conferences.size
    assert_instance_of Sportradar::Api::Football::Nfl::Conference, @nfl.conferences.first
  end

  def test_it_has_divisions
    VCR.use_cassette("nfl/league/hierarchy") do
      @nfl.get_hierarchy
    end
    assert_equal 8, @nfl.divisions.size
    assert_instance_of Sportradar::Api::Football::Nfl::Division, @nfl.divisions.first
  end

  def test_it_has_teams
    VCR.use_cassette("nfl/league/hierarchy") do
      @nfl.get_hierarchy
    end
    assert_equal 32, @nfl.teams.size
    assert_instance_of Sportradar::Api::Football::Nfl::Team, @nfl.teams.first
  end

  def test_it_has_standings
    VCR.use_cassette("nfl/league/standings_2016") do
      @nfl.update('season' => 2016)
      @nfl.get_standings
    end
    assert_equal 32, @nfl.teams.size
    assert @nfl.teams.all? { |t| t.record.win_pct }
  end

  def test_it_has_games
    VCR.use_cassette("nfl/league/schedule") do
      @nfl.get_schedule
    end
    assert_equal 256, @nfl.games.size
    assert_instance_of Sportradar::Api::Football::Nfl::Game, @nfl.games.first
  end

  def test_it_has_weeks
    VCR.use_cassette("nfl/league/schedule") do
      @nfl.get_schedule
    end
    assert_equal 17, @nfl.weeks.size
    assert_instance_of Sportradar::Api::Football::Nfl::Week, @nfl.weeks.first
  end

  def test_teams_have_venues
    VCR.use_cassette("nfl/league/hierarchy") do
      @nfl.get_hierarchy
    end
    assert_instance_of Sportradar::Api::Football::Venue, @nfl.teams.first.venue
  end

  def test_teams_have_required_attributes
    VCR.use_cassette("nfl/league/hierarchy") do
      @nfl.get_hierarchy
    end
    attributes = %i[id name alias market full_name]
    assert @nfl.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
