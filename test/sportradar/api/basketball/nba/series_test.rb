require 'test_helper'

class Sportradar::Api::Basketball::Nba::SeriesTest < Minitest::Test

  def setup
    @nba = Sportradar::Api::Basketball::Nba.new(year: 2015)
    VCR.use_cassette("nba/#{@nba.api.content_format}/league/series") do
      @nba.get_series_schedule
    end
  end

  def test_it_initializes_an_nba_season
    assert [:id, :name, :alias].all? { |att| @nba.send(att) }
    assert_instance_of Sportradar::Api::Basketball::Nba, @nba
  end

  def test_it_has_series
    assert_equal 15, @nba.series.size
    assert_instance_of Sportradar::Api::Basketball::Nba::Series, @nba.series.first
  end

  def test_series_have_required_attributes
    attributes = %i[id status title round start_date]
    assert @nba.series.all? { |series| attributes.all? { |att| series.send(att) } }
  end

end
