require 'test_helper'

class Sportradar::Api::Football::Nfl::TeamTest < Minitest::Test

  def setup
    data = { "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8" }
    @team = Sportradar::Api::Football::Nfl::Team.new(data)
  end

  def test_nfl_team_has_roster
    VCR.use_cassette("nfl/team/roster") do
      @team.get_roster
    end
    assert_equal 90, @team.players.size
    assert_kind_of Sportradar::Api::Football::Nfl::Player, @team.players.first
  end

  def test_nfl_team_season_stats
    VCR.use_cassette("nfl/team/season_stats_2016") do
      @team.get_season_stats(2016)
    end
    assert_equal 70, @team.players.size
  end

end
