require 'test_helper'

class Sportradar::Api::Basketball::Nba::ScheduleTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/league/daily_schedule-20170120") do
      @schedule = sr.daily_schedule(Date.new(2017, 1, 20))
    end
  end

  def test_it_initializes_an_nba_schedule
    assert [:id, :name, :alias, :date].all? { |att| @schedule.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Nba::Schedule, @schedule
  end

  def test_it_has_games
    assert_equal 9, @schedule.games.reject(&:postponed?).size
    assert_instance_of Sportradar::Api::Basketball::Nba::Game, @schedule.games.first
  end

  def test_games_have_required_attributes
    attributes = %i[id status coverage scheduled home away]
    assert @schedule.games.reject(&:postponed?).all? { |game| attributes.all? { |att| game.send(att) } }
  end

end
