require 'test_helper'

class Sportradar::Api::Basketball::Nba::StandingsTest < Minitest::Test

  def setup
    sr = Sportradar::Api::Basketball::Nba.new
    VCR.use_cassette("nba/#{sr.content_format}/league/standings") do
      @standings = sr.standings
    end
  end

  def test_it_initializes_an_nba_standings
    assert_instance_of Sportradar::Api::Basketball::Nba::Hierarchy, @standings
  end

  def test_teams_have_overall_record
    assert @standings.teams.all? { |team| team.record.win_pct }
    assert @standings.teams.all? { |team| team.record.wins }
    assert @standings.teams.all? { |team| team.record.losses }
  end

  def test_teams_have_all_records
    assert @standings.teams.all? { |team| !team.records.empty? }
    assert @standings.teams.all? { |team| team.record('home') }
    assert @standings.teams.all? { |team| team.record('road') }
    assert @standings.teams.all? { |team| team.record('over_500') }
    assert @standings.teams.all? { |team| team.record('below_500') }
  end

end
