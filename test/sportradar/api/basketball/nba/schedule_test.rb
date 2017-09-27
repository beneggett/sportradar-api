require 'test_helper'

class Sportradar::Api::Basketball::Nba::ScheduleTest < Minitest::Test

  def setup
    @nba = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/#{@nba.api.content_format}/league/daily_schedule-20170120") do
      @nba.get_daily_schedule(Date.new(2017, 1, 20))
    end
  end

  def test_it_initializes_an_nba_schedule
    assert [:id, :name, :alias].all? { |att| @nba.send(att) }
    # assert_instance_of Sportradar::Api::Basketball::Nba, @nba
  end

  def test_it_has_games
    assert_equal 9, @nba.games.reject(&:postponed?).size
    # assert_instance_of Sportradar::Api::Basketball::Nba::Game, @nba.games.first
  end

  def test_games_have_required_attributes
    attributes = %i[id status coverage scheduled home away]
    assert @nba.games.reject(&:postponed?).all? { |game| attributes.all? { |att| game.send(att) } }
  end

end
