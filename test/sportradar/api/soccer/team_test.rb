require 'test_helper'

class Sportradar::Api::Soccer::TeamTest < Minitest::Test

  def setup
    data = {"id"=>"sr:competitor:17", "name"=>"Manchester City"}
    @team = Sportradar::Api::Soccer::Team.new(data, league_group: 'eu')
  end

  def test_it_initializes_a_team
    assert_instance_of Sportradar::Api::Soccer::Team, @team
    assert_equal 'eu', @team.league_group
  end

  def test_it_has_players
    VCR.use_cassette("soccer/#{@team.api.content_format}/team/players") do
      res = @team.get_roster
      assert_equal 29, @team.players.size
      assert_instance_of Sportradar::Api::Soccer::Player, @team.players.first
    end
  end

  def test_it_has_a_schedule
    VCR.use_cassette("soccer/#{@team.api.content_format}/team/schedule") do
      res = @team.get_schedule
      assert_equal 34, @team.matches.size
      assert_instance_of Sportradar::Api::Soccer::Match, @team.matches.first
    end
  end

  def test_it_has_results
    VCR.use_cassette("soccer/#{@team.api.content_format}/team/results") do
      res = @team.get_results
      assert_equal 10, @team.matches.size
      assert_instance_of Sportradar::Api::Soccer::Match, @team.matches.first
      assert_equal "sr:competitor:17", @team.matches[2].winner_id
    end
  end

  def test_it_has_statistics
    VCR.use_cassette("soccer/#{@team.api.content_format}/team/statistics_without_tournament") do
      assert_raises Sportradar::Api::Error do
        res = @team.get_statistics
      end
    end
    VCR.use_cassette("soccer/#{@team.api.content_format}/team/statistics") do
      @team.tournament_id = 'sr:tournament:17'
      res = @team.get_statistics
      assert_equal 20, @team.players.size
      assert_instance_of Sportradar::Api::Soccer::Player, @team.players.first
      assert_instance_of Hash, @team.players.first.stats
      assert_equal({"total"=>1, "matches"=>9}, @team.players.first.stats['goals_scored'])
    end
  end

end
