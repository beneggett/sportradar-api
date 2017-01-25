require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::StandingsTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Ncaamb.new
    VCR.use_cassette("ncaamb/league/standings") do
      @standings = sr.standings
    end
  end

  def test_it_initializes_an_ncaamb_division
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, @standings
  end

end
