require 'test_helper'

class Sportradar::Api::Football::Nfl::GameStatisticsTest < Minitest::Test

  # ESPN box: http://www.espn.com/nfl/boxscore?gameId=400874536
  # ESPN pbp: http://www.espn.com/nfl/playbyplay?gameId=400874536
  def setup
    data = { "id"=>"0cb301fa-629d-4209-a8a6-9f76dfc695be" }
    @game = Sportradar::Api::Football::Nfl::Game.new(data)
    VCR.use_cassette("nfl/game/statistics_regulation") do
      @game.get_statistics
      @home_id = @game.home.id
      @away_id = @game.away.id
    end
  end

  def test_nfl_game_has_score
    assert_equal ({@home_id=>24, @away_id=>31}), @game.score
  end

  def test_nfl_game_has_stats
    assert_instance_of Sportradar::Api::Football::GameStats, @game.stats(:home)
    assert_instance_of Sportradar::Api::Football::GameStats, @game.stats(:away)
  end

  def test_nfl_game_statistics
    assert_equal 81, @game.stats(:home).rushing.yards
    assert_equal 28, @game.stats(:home).rushing.attempts
    
    assert_equal 8.1, @game.stats(:away).passing.avg_yards
    
    assert_equal 23, @game.stats(:home).receiving.receptions
    assert_equal 56.0, @game.stats(:home).kickoffs.average
  end

end
