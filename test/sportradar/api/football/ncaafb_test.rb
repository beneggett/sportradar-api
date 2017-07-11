require 'test_helper'

class Sportradar::Api::Football::NcaafbTest < Minitest::Test

  def setup
    @ncaafb = Sportradar::Api::Football::Ncaafb.new
  end

  def test_it_has_divisions
    VCR.use_cassette("ncaafb/league/hierarchy") do
      @ncaafb.get_hierarchy
    end
    assert_equal 1, @ncaafb.divisions.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Division, @ncaafb.divisions.first
  end

  def test_it_has_conferences
    VCR.use_cassette("ncaafb/league/hierarchy") do
      @ncaafb.get_hierarchy
    end
    assert_equal 11, @ncaafb.conferences.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Conference, @ncaafb.conferences.first
  end

  def test_it_has_teams
    VCR.use_cassette("ncaafb/league/hierarchy") do
      @ncaafb.get_hierarchy
    end
    assert_equal 130, @ncaafb.teams.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Team, @ncaafb.teams.first
  end

  def test_it_retrieves_teams_if_necessary
    VCR.use_cassette("ncaafb/league/hierarchy") do
      assert_equal 0, @ncaafb.divisions.size
      assert_equal 0, @ncaafb.conferences.size
      assert_equal 130, @ncaafb.teams.size
      assert_equal 1, @ncaafb.divisions.size
      assert_equal 11, @ncaafb.conferences.size
    end
  end

  def test_it_has_games
    @ncaafb.update('season' => 2016)
    VCR.use_cassette("ncaafb/league/schedule_2016") do
      @ncaafb.get_schedule
    end
    assert_equal 1561, @ncaafb.games.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Game, @ncaafb.games.first
  end

  def test_it_retrieves_games_if_necessary
    VCR.use_cassette("ncaafb/league/schedule_2016") do
      assert_equal 0, @ncaafb.weeks.size
      assert_equal 1561, @ncaafb.games.size
      assert_equal 20, @ncaafb.weeks.size
    end
  end

  def test_it_has_weeks
    @ncaafb.update('season' => 2016)
    VCR.use_cassette("ncaafb/league/schedule_2016") do
      @ncaafb.get_schedule
    end
    assert_equal 20, @ncaafb.weeks.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Week, @ncaafb.weeks.first
  end

  def test_teams_have_venues
    VCR.use_cassette("ncaafb/league/hierarchy") do
      @ncaafb.get_hierarchy
    end
    assert_instance_of Sportradar::Api::Football::Venue, @ncaafb.teams.first.venue
  end

  def test_teams_have_required_attributes
    VCR.use_cassette("ncaafb/league/hierarchy") do
      @ncaafb.get_hierarchy
    end
    attributes = %i[id name market full_name]
    assert @ncaafb.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
