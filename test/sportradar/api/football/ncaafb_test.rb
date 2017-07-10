require 'test_helper'

class Sportradar::Api::Football::NcaafbTest < Minitest::Test

  def setup
    @ncaafb = Sportradar::Api::Football::Ncaafb.new
    VCR.use_cassette("ncaafb/league") do
      @ncaafb.get_hierarchy
      # @ncaafb.get_schedule
      # @ncaafb.get_standings
    end
  end

  def test_it_has_divisions
    assert_equal 1, @ncaafb.divisions.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Division, @ncaafb.divisions.first
  end

  def test_it_has_conferences
    assert_equal 11, @ncaafb.conferences.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Conference, @ncaafb.conferences.first
  end

  def test_it_has_teams
    assert_equal 130, @ncaafb.teams.size
    assert_instance_of Sportradar::Api::Football::Ncaafb::Team, @ncaafb.teams.first
  end

  # def test_it_has_games
  #   assert_equal 256, @ncaafb.games.size
  #   assert_instance_of Sportradar::Api::Football::Ncaafb::Game, @ncaafb.games.first
  # end

  # def test_it_has_weeks
  #   assert_equal 17, @ncaafb.weeks.size
  #   assert_instance_of Sportradar::Api::Football::Ncaafb::Week, @ncaafb.weeks.first
  # end

  def test_teams_have_venues
    assert_instance_of Sportradar::Api::Football::Venue, @ncaafb.teams.first.venue
  end

  def test_teams_have_required_attributes
    attributes = %i[id name market full_name]
    assert @ncaafb.teams.all? { |team| attributes.all? { |att| team.send(att)} }
  end

end
