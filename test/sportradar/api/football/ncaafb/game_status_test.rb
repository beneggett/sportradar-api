require 'test_helper'

class Sportradar::Api::Football::Ncaafb::GameStatusTest < Minitest::Test

  def setup
    data = {"id"=>"f8ac7454-980d-496a-99af-5824d5f3eea2",
      "status"=>"closed",
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
    @all_helpers = %i[postponed? unnecessary? cancelled? delayed? future? started? halftime? finished? completed? closed?]
  end


  def test_ncaafb_game_status_when_closed
    assert @game.finished?
    assert @game.closed?
    (@all_helpers - [:finished?, :closed?]).each do |status|
      refute @game.send(status)
    end
  end

  def test_ncaafb_game_status_when_inprogress
    @game.status = 'inprogress'
    assert @game.started?
    (@all_helpers - [:started?]).each do |status|
      refute @game.send(status)
    end
  end

  def test_ncaafb_game_status_when_halftime
    @game.status = 'halftime'
    assert @game.started?
    assert @game.halftime?
    (@all_helpers - [:started?, :halftime?]).each do |status|
      refute @game.send(status)
    end
  end

end
