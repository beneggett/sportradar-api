require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::StandingsTest < Minitest::Test

  def setup
    @ncaamb = Sportradar::Api::Basketball::Ncaamb.new(year: 2016)
    VCR.use_cassette("ncaamb/#{@ncaamb.api.content_format}/league/standings") do
      @ncaamb.get_standings
    end
  end

  def test_it_initializes_an_ncaamb_division
    assert_instance_of Sportradar::Api::Basketball::Ncaamb::Division, @ncaamb.division('D1')
  end

  def test_teams_have_overall_record
    assert @ncaamb.teams.all? { |team| team.record.win_pct }
    assert @ncaamb.teams.all? { |team| team.record.wins }
    assert @ncaamb.teams.all? { |team| team.record.losses }
  end

end
