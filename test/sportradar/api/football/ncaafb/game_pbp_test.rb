require 'test_helper'

class Sportradar::Api::Football::Ncaafb::GamePbpTest < Minitest::Test

  def setup
    data = {"id"=>"f8ac7454-980d-496a-99af-5824d5f3eea2",
      "scheduled"=>"2016-11-26T02:30:00+00:00",
      "coverage"=>"full",
      "home_rotation"=>"",
      "away_rotation"=>"",
      "home"=>"ARI",
      "away"=>"ASU",
      "year"=>2016,
      "type"=>'REG',
      "week_number"=>13,
    }
    @game = Sportradar::Api::Football::Ncaafb::Game.new(data)
    VCR.use_cassette("ncaafb/game/pbp_regulation") do
      @game.get_pbp
      @home_id = @game.home_alias
      @away_id = @game.away_alias
    end
  end

  def test_ncaafb_game_pbp
    assert_equal 4, @game.quarters.size
    assert_equal 34, @game.drives.size
    assert_equal 228, @game.plays.size
  end

  def test_ncaafb_game_play_timing
    assert @game.plays.all?(&:clock)
  end

  def test_ncaafb_game_plays_have_required_attributes
    assert @game.plays.all?(&:description)
  end

end
