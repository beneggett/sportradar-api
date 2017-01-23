require 'test_helper'

class Sportradar::Api::Basketball::Nba::GamePbpTest < Minitest::Test

  def setup
    @attrs = { "id" => "3700bb52-50f0-4929-b6b0-ae0b3cbad019" }
    @game = Sportradar::Api::Basketball::Nba::Game.new(@attrs)
    VCR.use_cassette("nba/game/pbp_regulation") do
      @game.get_pbp
    end
  end

  def test_nba_game_pbp
    assert_equal 4, @game.quarters.size
    assert_equal 421, @game.plays.size
  end

  def test_nba_game_play_timing
    assert @game.plays.all?(&:game_seconds)
    assert @game.plays.all?(&:clock_seconds)
    assert @game.plays.all?(&:quarter)
    assert_equal @game.plays.map(&:points).inject(:+), @game.points("583ec97e-fb46-11e1-82cb-f4ce4684ea4c") + @game.points("583ecda6-fb46-11e1-82cb-f4ce4684ea4c")

    play = @game.plays[100]
    assert_equal 733, play.game_seconds
    assert_equal 707, play.clock_seconds
    assert_equal 2,   play.quarter

    play = @game.plays[300]
    assert_equal 2069, play.game_seconds
    assert_equal 91,   play.clock_seconds
    assert_equal 3,    play.quarter
  end

  def test_nba_game_pbp_quarter_scoring
    assert_equal 26, @game.scoring.dig(1, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 18, @game.scoring.dig(1, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 29, @game.scoring.dig(2, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 30, @game.scoring.dig(2, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 33, @game.scoring.dig(3, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 15, @game.scoring.dig(3, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 25, @game.scoring.dig(4, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 15, @game.scoring.dig(4, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
  end

end
