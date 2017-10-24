require 'test_helper'

class Sportradar::Api::Soccer::TournamentTest < Minitest::Test

  def setup
    data = {"id"=>"sr:tournament:17",
    "name"=>"Premier League",
    "sport"=>{"id"=>"sr:sport:1", "name"=>"Soccer"},
    "category"=>{"id"=>"sr:category:1", "name"=>"England", "country_code"=>"ENG"},
    "current_season"=>{"id"=>"sr:season:40942", "name"=>"Premier League 17/18", "start_date"=>"2017-08-11", "end_date"=>"2018-05-14", "year"=>"17/18"},
    "season_coverage_info"=>{"scheduled"=>381, "played"=>70, "max_coverage_level"=>"platinum", "max_covered"=>70, "min_coverage_level"=>"platinum", "id"=>"sr:season:40942"}}
    @tournament = Sportradar::Api::Soccer::Tournament.new(data, league_group: 'eu')
  end

  def test_it_initializes_a_tournament
    assert_instance_of Sportradar::Api::Soccer::Tournament, @tournament
    assert_equal 'eu', @tournament.league_group
  end

  def test_it_has_seasons
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/seasons") do
      res = @tournament.get_seasons
      assert_equal 25, @tournament.seasons.size
      assert_instance_of Sportradar::Api::Soccer::Season, @tournament.seasons.first
    end
  end

  def test_it_has_a_schedule
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/schedule") do
      res = @tournament.get_schedule
      assert_equal 380, @tournament.matches.size
      assert_instance_of Sportradar::Api::Soccer::Match, @tournament.matches.first
    end
  end

  def test_it_has_results
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/results") do
      res = @tournament.get_results
      assert_equal 70, @tournament.matches.size
      assert_instance_of Sportradar::Api::Soccer::Match, @tournament.matches.first
      assert_equal "sr:competitor:6", @tournament.matches[2].winner_id
    end
  end

  def test_it_has_info
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/info") do
      res = @tournament.get_info
      assert_equal 1, @tournament.groups.size
      assert_instance_of Sportradar::Api::Soccer::TeamGroup, @tournament.groups.first
      refute @tournament.group.name
    end
  end

  def test_it_has_leaders
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/leaders") do
      res = @tournament.get_leaders
    end
  end

  def test_it_has_live_standings
    VCR.use_cassette("soccer/#{@tournament.api.content_format}/tournament/live_standings") do
      res = @tournament.get_live_standings
      assert_equal 3, @tournament.standings.size
      assert_instance_of Sportradar::Api::Soccer::Standing, @tournament.standings.first
      assert_instance_of Sportradar::Api::Soccer::Standing, @tournament.standings('total')
      assert_equal 'total', @tournament.standings('total').type
      assert_instance_of Sportradar::Api::Soccer::Team, @tournament.standings('total').teams.first
    end
  end

end
