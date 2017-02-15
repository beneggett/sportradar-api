require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::ScheduleTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/#{sr.content_format}/league/daily_schedule-20170121") do
      @schedule = sr.daily_schedule(Date.new(2017, 1, 21))
    end
  end

  def test_it_initializes_an_ncaamb_schedule
    assert [:id, :name, :alias, :date].all? { |att| @schedule.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Schedule, @schedule
  end

  def test_it_has_games
    assert_equal 140, @schedule.games.reject(&:postponed?).size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Game, @schedule.games.first
  end

  def test_games_have_required_attributes
    attributes = %i[id status coverage scheduled home away]
    assert @schedule.games.reject(&:postponed?).all? { |game| attributes.all? { |att| game.send(att) } }
  end

end
