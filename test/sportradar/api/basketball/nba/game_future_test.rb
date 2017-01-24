require 'test_helper'

class Sportradar::Api::Basketball::Nba::GameFutureTest < Minitest::Test

  def setup
    @game = Sportradar::Api::Basketball::Nba::Game.new('id' => "fdebfa54-dbdb-4992-baa0-729394bd9610")
  end

  def test_nba_game_get_pbp
    VCR.use_cassette("nba/game/pbp_future") do
      @game.get_pbp
      assert_equal ({}), @game.scoring
    end
  end

  def test_nba_game_get_summary
    VCR.use_cassette("nba/game/summary_future") do
      assert_equal ({}), @game.scoring
    end
  end

end
