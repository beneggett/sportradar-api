require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::GamePbpTest < Minitest::Test

  def setup
    # ESPN boxscore: http://www.espn.com/mens-college-basketball/boxscore?gameId=400915635
    game_id = "29111b80-992d-4e32-a88d-220fb4bd3121"
    @game = Sportradar::Api::Basketball::Ncaamb::Game.new('id' => game_id)
    VCR.use_cassette("ncaamb/game/pbp_regulation") do
      @game.get_pbp
      @home_id = @game.home_id
      @away_id = @game.away_id
    end
  end

  def test_ncaamb_game_pbp
    assert_equal 2, @game.halfs.size
    assert_equal 318, @game.plays.size
  end

  def test_ncaamb_game_play_timing
    assert @game.plays.all?(&:game_seconds)
    assert @game.plays.all?(&:clock_seconds)
    assert @game.plays.all?(&:half)
    assert_equal @game.plays.map(&:points).inject(:+), @game.points(@away_id) + @game.points(@home_id)

    play = @game.plays[100]
    assert_equal 844, play.game_seconds
    assert_equal 356, play.clock_seconds
    assert_equal 1,   play.half

    play = @game.plays[300]
    assert_equal 2351, play.game_seconds
    assert_equal 49,   play.clock_seconds
    assert_equal 2,    play.half
  end

  def test_ncaamb_game_play_half
    assert @game.plays.all? { |play| play.half.nonzero? }
  end

  def test_ncaamb_game_pbp_scoring
    assert_equal 48, @game.scoring.dig(1, @away_id)
    assert_equal 37, @game.scoring.dig(1, @home_id)
    assert_equal 48, @game.scoring.dig(2, @away_id)
    assert_equal 48, @game.scoring.dig(2, @home_id)
  end

  def test_ncaamb_game_play_type_lookup
    assert_equal 96, @game.plays_by_type('shot_made').size
    assert_equal 30, @game.plays_by_type('free_throw_made').size
    assert_equal 19, @game.plays_by_type('three_point_made').size
    assert_equal 66, @game.plays_by_type('three_point_made', 'two_point_made').size
    assert_equal 73, @game.plays_by_type('three_point_miss', 'two_point_miss').size
    assert_equal 34, @game.plays_by_type('foul').size
    assert_equal 35, @game.plays_by_type('foul', 'technical_foul').size
    assert_equal 7, @game.plays_by_type('shot_miss').select(&:block).size
    assert_equal 33, @game.plays_by_type('shot_made').select(&:assist).size
    assert_equal 68, @game.plays_by_type('rebound').select(&:player_id).size
    assert_equal 8, @game.plays_by_type('turnover').select(&:steal).size
  end

  def test_ncaamb_game_plays_have_required_attributes
    assert @game.plays.all?(&:display_type)
    assert @game.plays.all?(&:description)
  end

  def test_ncaamb_game_plays_have_additional_attributes
    assert @game.plays_by_type('shot_made').all?(&:made?)
    assert @game.plays_by_type('shot_miss').none?(&:made?)
    assert_equal 0, @game.plays_by_type('shot_miss').map(&:points).inject(:+)
    assert_equal 181, @game.plays_by_type('shot_made').map(&:points).inject(:+)
  end

end
