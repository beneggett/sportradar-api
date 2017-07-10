require 'test_helper'

class Sportradar::Api::Football::Ncaafb::TeamTest < Minitest::Test

  def setup
    data = { "id"=>"ARI" }
    @team = Sportradar::Api::Football::Ncaafb::Team.new(data)
  end

  def test_ncaafb_team_has_roster
    VCR.use_cassette("ncaafb/team/roster") do
      @team.get_roster
    end
    assert_equal 73, @team.players.size
    assert_kind_of Sportradar::Api::Football::Ncaafb::Player, @team.players.first
  end

  def test_ncaafb_team_season_stats
    VCR.use_cassette("ncaafb/team/season_stats_2016") do
      @team.get_season_stats(2016)
    end
    assert_equal 123, @team.players.size
  end

end
