require 'test_helper'

class Sportradar::Api::Football::Ncaafb::GameStatisticsTest < Minitest::Test

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
    VCR.use_cassette("ncaafb/game/statistics_regulation") do
      @game.get_statistics
      @home_id = @game.home_alias
      @away_id = @game.away_alias
    end
  end


  def test_ncaafb_game_has_score
    assert_equal ({"ARI"=>56, "ASU"=>35}), @game.score
  end

  def test_ncaafb_game_has_stats
    assert_instance_of Sportradar::Api::Football::GameStats, @game.stats(:home)
    assert_instance_of Sportradar::Api::Football::GameStats, @game.stats(:away)
  end

end
