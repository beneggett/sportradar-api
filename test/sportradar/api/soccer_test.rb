require 'test_helper'

class Sportradar::Api::SoccerTest < Minitest::Test

  def match_id
    "357607e9-87cd-4848-b53e-0485d9c1a3bc"
  end

  def team_id
    "b78b9f61-0697-4347-a1b6-b7685a130eb1"
  end

  def player_id
    "2aeacd39-3f9c-42af-957e-9df8573973c4"
  end

  def simulation_game_id
    "22653ed5-0b2c-4e30-b10c-c6d51619b52b"
  end

  def test_it_accepts_a_valid_access_level
    good = Sportradar::Api::Soccer.new
    assert_kind_of Sportradar::Api::Soccer, good
    assert_raises Sportradar::Api::Error::InvalidAccessLevel do
      Sportradar::Api::Soccer.new('na', 'dumb')
    end
  end

  def test_it_accepts_a_valid_league
    good = Sportradar::Api::Soccer.new
    assert_kind_of Sportradar::Api::Soccer, good
    assert_raises Sportradar::Api::Error::InvalidLeague do
      Sportradar::Api::Soccer.new('dumb', 't')
    end
  end

  def test_it_makes_a_good_schedule_request
    VCR.use_cassette("soccer good schedule request") do
      request = Sportradar::Api::Soccer.new.schedule
      assert_kind_of Sportradar::Api::Soccer::Schedule, request
    end
  end

  def test_it_makes_a_good_daily_schedule_request
    VCR.use_cassette("soccer good daily schedule request") do
      request = Sportradar::Api::Soccer.new.daily_schedule(good_date)
      assert_kind_of Sportradar::Api::Soccer::Schedule, request
      assert request.matches.present?
    end
  end

  def test_it_makes_a_bad_daily_schedule_request
    VCR.use_cassette("soccer bad daily schedule request") do
      request = Sportradar::Api::Soccer.new.daily_schedule(old_date)
      assert_kind_of Sportradar::Api::Soccer::Schedule, request
      refute request.matches.present?
    end
  end

  def test_it_makes_a_good_daily_summary_request
    VCR.use_cassette("soccer good daily summary request") do
      request = Sportradar::Api::Soccer.new.daily_summary(good_date)
      assert_kind_of Sportradar::Api::Soccer::Summary, request
      assert request.matches.present?
    end
  end

  def test_it_makes_a_bad_daily_summary_request
    VCR.use_cassette("soccer bad daily summary request") do
      request = Sportradar::Api::Soccer.new.daily_summary(old_date)
      assert_kind_of Sportradar::Api::Soccer::Summary, request
      refute request.matches.present?
    end
  end

  def test_it_makes_a_good_daily_boxscore_request
    VCR.use_cassette("soccer good daily boxscore request") do
      request = Sportradar::Api::Soccer.new.daily_boxscore(good_date)
      assert_kind_of Sportradar::Api::Soccer::Boxscore, request
      assert request.matches.present?
    end
  end

  def test_it_makes_a_bad_daily_boxscore_request
    VCR.use_cassette("soccer bad daily boxscore request") do
      request = Sportradar::Api::Soccer.new.daily_boxscore(old_date)
      assert_kind_of Sportradar::Api::Soccer::Boxscore, request
      refute request.matches.present?
    end
  end

  def test_it_makes_a_good_match_summary_request
    VCR.use_cassette("soccer good match summary request") do
      request = Sportradar::Api::Soccer.new.match_summary(match_id)
      assert_kind_of Sportradar::Api::Soccer::Summary, request
      assert request.matches.present?
    end
  end

  def test_it_makes_a_bad_match_summary_request
    VCR.use_cassette("soccer bad match summary request") do
      request = Sportradar::Api::Soccer.new.match_summary('dumb')
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_makes_a_good_match_boxscore_request
    VCR.use_cassette("soccer good match boxscore request") do
      request = Sportradar::Api::Soccer.new.match_boxscore(match_id)
      assert_kind_of Sportradar::Api::Soccer::Boxscore, request
      assert request.matches.present?
    end
  end

  def test_it_makes_a_bad_match_boxscore_request
    VCR.use_cassette("soccer bad match boxscore request") do
      request = Sportradar::Api::Soccer.new.match_boxscore('dumb')
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_makes_a_good_team_profile_request
    VCR.use_cassette("soccer good team profile request") do
      request = Sportradar::Api::Soccer.new.team_profile(team_id)
      assert_kind_of Sportradar::Api::Soccer::Team, request
    end
  end

  def test_it_makes_a_bad_team_profile_request
    VCR.use_cassette("soccer bad team profile request") do
      request = Sportradar::Api::Soccer.new.team_profile('dumb')
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_makes_a_good_player_profile_request
    VCR.use_cassette("soccer good player profile request") do
      request = Sportradar::Api::Soccer.new.player_profile(player_id)
      assert_kind_of Sportradar::Api::Soccer::Player, request
    end
  end

  def test_it_makes_a_bad_player_profile_request
    VCR.use_cassette("soccer bad player profile request") do
      request = Sportradar::Api::Soccer.new.player_profile('dumb')
      refute_kind_of Sportradar::Api::Soccer::Player, request
    end
  end

  def test_it_makes_a_good_player_rankings_request
    VCR.use_cassette("soccer good player rankings request") do
      request = Sportradar::Api::Soccer.new.player_rankings
      assert_kind_of Sportradar::Api::Soccer::Ranking, request
    end
  end

  def test_it_makes_a_good_team_hierarchy_request
    VCR.use_cassette("soccer good team hierarchy request") do
      request = Sportradar::Api::Soccer.new.team_hierarchy
      assert_kind_of Sportradar::Api::Soccer::Hierarchy, request
    end
  end

  def test_it_makes_a_good_team_standings_request
    VCR.use_cassette("soccer good team standings request") do
      request = Sportradar::Api::Soccer.new.team_standings
      assert_kind_of Sportradar::Api::Soccer::Standing, request
    end
  end


  def test_simulation_match
    assert_equal simulation_game_id, Sportradar::Api::Soccer.new.simulation_match
  end

  def test_it_makes_a_good_simulation_match_boxscore_request
    VCR.use_cassette("soccer good simulation match boxscore request") do
      request = Sportradar::Api::Soccer.new.match_boxscore(simulation_game_id)
      assert_kind_of Sportradar::Api::Soccer::Boxscore, request
    end
  end


end
