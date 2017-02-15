require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::TeamTest < Minitest::Test

  def setup
    @response = {"id"=>"9b166a3f-e64b-4825-bb6b-92c6f0418263",
               "name"=>"Wildcats",
               "market"=>"Arizona",
               "alias"=>"ARIZ",
               "venue"=>{"id"=>"60c78748-ee0e-4764-9c8c-141e876d2abf", "name"=>"McKale Center", "capacity"=>"14655", "address"=>"1 National Championship Drive", "city"=>"Tuscon", "state"=>"AZ", "zip"=>"85721", "country"=>"USA"}}

    @team = Sportradar::Api::Basketball::Ncaamb::Team.new(@response)
  end

  def test_ncaamb_team_initializes
    assert [:id, :name, :alias, :market, :venue].all? { |e| @team.send(e) }
    assert_instance_of Sportradar::Api::Basketball::Venue, @team.venue
  end

  def test_ncaamb_team_has_full_name
    assert_equal [@team.market, @team.name].join(' '), @team.full_name
  end

  def test_ncaamb_team_roster
    VCR.use_cassette("ncaamb/#{@team.api.content_format}/team/roster") do
      assert_equal 16, @team.players.size
    end
  end

  def test_ncaamb_team_season_stats
    VCR.use_cassette("ncaamb/#{@team.api.content_format}/team/season_stats") do
      @team.get_season_stats
      refute_empty @team.team_stats
      refute_empty @team.player_stats
      assert_equal 16, @team.player_stats.size

      player = @team.players.first
      refute_empty player.totals
      refute_empty player.averages
      assert_equal 30, player.totals.size
      assert_equal 20, player.averages.size
    end
  end

end
