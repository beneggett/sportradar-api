require 'test_helper'

class Sportradar::Api::Football::Nfl::GamePbpTest < Minitest::Test

  # ESPN box: http://www.espn.com/nfl/boxscore?gameId=400874536
  # ESPN pbp: http://www.espn.com/nfl/playbyplay?gameId=400874536
  def setup
    data = { "id"=>"0cb301fa-629d-4209-a8a6-9f76dfc695be" }
    @game = Sportradar::Api::Football::Nfl::Game.new(data)
    VCR.use_cassette("nfl/game/pbp_regulation") do
      @game.get_pbp
      @home_id = @game.home.id
      @away_id = @game.away.id
    end
  end

  def test_nfl_game_has_score
    assert_equal ({@home_id=>24, @away_id=>31}), @game.score
  end

  def test_nfl_game_pbp
    assert_equal 4, @game.quarters.size
    assert_equal 21, @game.drives.size
    assert_equal 168, @game.plays.size
  end

  def test_nfl_game_play_timing
    assert @game.plays.all?(&:clock)
  end

  def test_nfl_game_plays_have_required_attributes
    assert @game.plays.all?(&:description)
  end

end
