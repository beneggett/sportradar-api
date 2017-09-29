require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::ScheduleTest < Minitest::Test

  def setup
    @ncaamb = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/#{@ncaamb.api.content_format}/league/daily_schedule-20170121") do
      @ncaamb.get_daily_schedule(Date.new(2017, 1, 21))
    end
  end

  def test_it_initializes_an_ncaamb_schedule
    assert [:id, :name, :alias].all? { |att| @ncaamb.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb, @ncaamb
  end

  def test_it_has_games
    assert_equal 140, @ncaamb.games.reject(&:postponed?).size
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Game, @ncaamb.games.first
  end

  def test_games_have_required_attributes
    attributes = %i[id status coverage scheduled home away]
    assert @ncaamb.games.reject(&:postponed?).all? { |game| attributes.all? { |att| game.send(att) } }
  end

end
