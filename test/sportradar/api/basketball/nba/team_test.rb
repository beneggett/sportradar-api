require 'test_helper'

class Sportradar::Api::Basketball::Nba::TeamTest < Minitest::Test

  def setup
    @attrs = {"id"=>"583ec8d4-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Wizards",
              "market"=>"Washington",
              "alias"=>"WAS",
              "venue"=>{"id"=>"f62d5b49-d646-56e9-ba60-a875a00830f8", "name"=>"Verizon Center", "capacity"=>"20356", "address"=>"601 F St. N.W.", "city"=>"Washington", "state"=>"DC", "zip"=>"20004", "country"=>"USA"}}

    @team = Sportradar::Api::Basketball::Nba::Team.new(@attrs)
  end

  def test_nba_team_initializes
    assert [:id, :name, :alias, :market, :venue].all? { |e| @team.send(e) }
    assert_instance_of Sportradar::Api::Basketball::Venue, @team.venue
  end

  def test_nba_team_has_full_name
    assert_equal [@team.market, @team.name].join(' '), @team.full_name
  end

  def test_nba_team_roster
    VCR.use_cassette("nba/#{@team.api.content_format}/team/roster") do
      @team.get_roster
      assert_equal 15, @team.players.size
      player = @team.players.first
      assert player.height
      assert player.weight
    end
  end

  def test_nba_team_season_stats
    VCR.use_cassette("nba/#{@team.api.content_format}/team/season_stats") do
      @team.get_season_stats
      refute_empty @team.team_stats
      refute_empty @team.player_stats
      assert_equal 15, @team.player_stats.size

      player = @team.players.first
      refute_empty player.totals
      refute_empty player.averages
      assert_equal 30, player.totals.size
      assert_equal 20, player.averages.size
    end
  end

end
