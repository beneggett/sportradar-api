require 'test_helper'

class Sportradar::Api::Football::GameStatusTest < Minitest::Test

  def setup
    data = { "id"=>"some-id" }
    @game = Sportradar::Api::Football::Game.new(data)
    @all_helpers = %i[postponed? unnecessary? cancelled? delayed? future? started? halftime? finished? completed? closed?]
  end


  def test_ncaafb_game_status_when_closed
    @game.status = 'closed'
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

  def test_ncaafb_game_status_when_future
    @game.status = 'scheduled'
    assert @game.future?
    (@all_helpers - [:future?]).each do |status|
      refute @game.send(status)
    end
  end

end
