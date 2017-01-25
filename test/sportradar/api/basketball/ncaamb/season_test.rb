require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::SeasonTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/league/season") do
      @season = sr.schedule
    end
  end

  def test_it_initializes_an_ncaamb_season
    assert [:id, :name, :alias].all? { |att| @season.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Season, @season
  end

  def test_it_has_games
    # assert_equal 41 * 30 + 1, @season.games.reject(&:postponed?).size # regular season games plus all-star game
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Game, @season.games.first
  end

  def test_games_have_required_attributes
    attributes = %i[id status coverage scheduled home away]
    assert @season.games.reject(&:postponed?).all? { |game| attributes.all? { |att| game.send(att) } }
  end

end
