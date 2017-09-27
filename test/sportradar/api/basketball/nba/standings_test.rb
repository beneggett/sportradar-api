require 'test_helper'

class Sportradar::Api::Basketball::Nba::StandingsTest < Minitest::Test

  def setup
    @nba = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/#{@nba.api.content_format}/league/standings") do
      @nba.standings
    end
  end

  def test_it_initializes_an_nba_standings
    assert_instance_of Sportradar::Api::Basketball::Nba, @nba
  end

  def test_teams_have_overall_record
    assert @nba.teams.all? { |team| team.record.win_pct }
    assert @nba.teams.all? { |team| team.record.wins }
    assert @nba.teams.all? { |team| team.record.losses }
  end

  def test_teams_have_all_records
    assert @nba.teams.all? { |team| !team.records.empty? }
    assert @nba.teams.all? { |team| team.record('home') }
    assert @nba.teams.all? { |team| team.record('road') }
    assert @nba.teams.all? { |team| team.record('over_500') }
    assert @nba.teams.all? { |team| team.record('below_500') }
  end

end
