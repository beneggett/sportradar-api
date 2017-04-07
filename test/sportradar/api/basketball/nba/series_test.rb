require 'test_helper'

class Sportradar::Api::Basketball::Nba::SeriesTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/#{sr.content_format}/league/series") do
      @season = sr.series_schedule(2015)
    end
  end

  def test_it_initializes_an_nba_season
    assert [:id, :name, :alias].all? { |att| @season.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Nba::Season, @season
  end

  def test_it_has_series
    assert_equal 15, @season.series.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Series, @season.series.first
  end

  def test_series_have_required_attributes
    attributes = %i[id status title round start_date]
    assert @season.series.all? { |series| attributes.all? { |att| series.send(att) } }
  end

end
