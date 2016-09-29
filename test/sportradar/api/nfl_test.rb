require 'test_helper'

class Sportradar::Api::NflTest < Minitest::Test

  def simulation_game_id
    "f45b4a31-b009-4039-8394-42efbc6d5532"
  end

  def past_game_id
    "0141a0a5-13e5-4b28-b19f-0c3923aaef6e"
  end

  def player_id
    "ede260be-5ae6-4a06-887b-e4a130932705"
  end

  def team_id
    "97354895-8c77-4fd4-a860-32e62ea7382a"
  end

  def test_it_accepts_a_valid_access_level
    good = Sportradar::Api::Nfl.new('o')
    assert_kind_of Sportradar::Api::Nfl, good
    assert_raises Sportradar::Api::Error::InvalidAccessLevel do
      Sportradar::Api::Nfl.new('dumb')
    end
  end

  def test_it_makes_a_good_schedule_request
    VCR.use_cassette("nfl good schedule request") do
      request = Sportradar::Api::Nfl.new.schedule
      assert_kind_of Sportradar::Api::Nfl::Season, request
    end
  end

  def test_it_makes_a_bad_schedule_request_for_past_date
    VCR.use_cassette("nfl bad schedule request for past date") do
      request = Sportradar::Api::Nfl.new.schedule(1950)
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_doesnt_make_a_request_because_of_bad_season
    assert_raises Sportradar::Api::Error::InvalidSeason do
      Sportradar::Api::Nfl.new.schedule(2016, 'bad')
    end
  end

  def test_it_makes_a_good_weekly_schedule_request
    VCR.use_cassette("nfl good weekly schedule request") do
      request = Sportradar::Api::Nfl.new.weekly_schedule
      assert_kind_of Sportradar::Api::Nfl::Season, request
    end
  end

  def test_it_makes_a_bad_weekly_schedule_request
    VCR.use_cassette("nfl bad weekly schedule request") do
      request = Sportradar::Api::Nfl.new.weekly_schedule("2", "1950", "dumb")
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_makes_a_good_weekly_depth_charts_request
    VCR.use_cassette("nfl good weekly depth_charts request") do
      request = Sportradar::Api::Nfl.new.weekly_depth_charts
      assert_kind_of Sportradar::Api::Nfl::LeagueDepthChart, request
    end
  end

  def test_it_makes_a_bad_weekly_depth_charts_request
    VCR.use_cassette("nfl bad weekly depth charts request") do
      request = Sportradar::Api::Nfl.new.weekly_depth_charts("2", "1950", "dumb")
      assert_kind_of Sportradar::Api::Error, request
    end
  end

  def test_it_makes_a_good_weekly_injuries_request
    VCR.use_cassette("nfl good weekly injuries request") do
      request = Sportradar::Api::Nfl.new.weekly_injuries
      assert_kind_of Sportradar::Api::Nfl::Season, request
    end
  end

  def test_it_makes_a_good_game_boxscore_request
    VCR.use_cassette("nfl good past game boxscore request") do
      request = Sportradar::Api::Nfl.new.game_boxscore(past_game_id)
      assert_kind_of Sportradar::Api::Nfl::Game, request
    end
  end

  def test_it_makes_a_not_found_game_boxscore_request
    VCR.use_cassette("nfl not found past game boxscore request") do
      request = Sportradar::Api::Nfl.new.game_boxscore('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_game_roster_request
    VCR.use_cassette("nfl good past game roster request") do
      request = Sportradar::Api::Nfl.new.game_roster(past_game_id)
      assert_kind_of Sportradar::Api::Nfl::Game, request
    end
  end

  def test_it_makes_a_not_found_game_roster_request
    VCR.use_cassette("nfl not found past game roster request") do
      request = Sportradar::Api::Nfl.new.game_roster('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_game_statistics_request
    VCR.use_cassette("nfl good past game statistics request") do
      request = Sportradar::Api::Nfl.new.game_statistics(past_game_id)
      assert_kind_of Sportradar::Api::Nfl::Game, request
    end
  end

  def test_it_makes_a_not_found_game_statistics_request
    VCR.use_cassette("nfl not found past game statistics request") do
      request = Sportradar::Api::Nfl.new.game_statistics('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_play_by_play_request
    VCR.use_cassette("nfl good past play_by_play request") do
      request = Sportradar::Api::Nfl.new.play_by_play(past_game_id)
      assert_kind_of Sportradar::Api::Nfl::Game, request
    end
  end

  def test_it_makes_a_not_found_play_by_play_request
    VCR.use_cassette("nfl not found past play_by_play request") do
      request = Sportradar::Api::Nfl.new.play_by_play('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_player_profile_request
    VCR.use_cassette("nfl good player_profile request") do
      request = Sportradar::Api::Nfl.new.player_profile(player_id)
      assert_kind_of Sportradar::Api::Nfl::Player, request
    end
  end

  def test_it_makes_a_not_found_player_profile_request
    VCR.use_cassette("nfl not found player_profile request") do
      request = Sportradar::Api::Nfl.new.player_profile('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_seasonal_statistics_request
    VCR.use_cassette("nfl good seasonal_statistics request") do
      request = Sportradar::Api::Nfl.new.seasonal_statistics(team_id)
      assert_kind_of Sportradar::Api::Nfl::Season, request
    end
  end

  def test_it_makes_a_not_found_seasonal_statistics_request
    VCR.use_cassette("nfl not found seasonal_statistics request") do
      request = Sportradar::Api::Nfl.new.seasonal_statistics('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end


  def test_it_makes_a_good_team_profile_request
    VCR.use_cassette("nfl good past team_profile request") do
      request = Sportradar::Api::Nfl.new.team_profile(team_id)
      assert_kind_of Sportradar::Api::Nfl::Team, request
    end
  end

  def test_it_makes_a_not_found_team_profile_request
    VCR.use_cassette("nfl not found past team_profile request") do
      request = Sportradar::Api::Nfl.new.team_profile('dumb')
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_league_hierarchy_request
    VCR.use_cassette("nfl good past league_hierarchy request") do
      request = Sportradar::Api::Nfl.new.league_hierarchy
      assert_kind_of Sportradar::Api::Nfl::Hierarchy, request
    end
  end

  def test_it_makes_a_good_standings_request
    VCR.use_cassette("nfl good standings request") do
      request = Sportradar::Api::Nfl.new.standings
      assert_kind_of Sportradar::Api::Nfl::Season, request
    end
  end

  def test_it_makes_a_not_found_standings_request
    VCR.use_cassette("nfl not found standings request") do
      request = Sportradar::Api::Nfl.new.standings(1950)
      assert_kind_of Sportradar::Api::Error, request
      assert_equal request.code, 404
    end
  end

  def test_it_makes_a_good_daily_change_log_request
    VCR.use_cassette("nfl good daily_change_log request") do
      request = Sportradar::Api::Nfl.new.daily_change_log
      assert_kind_of Sportradar::Api::Nfl::Changelog, request
    end
  end

  def test_it_makes_a_good_simulation_game_boxscore_request
    VCR.use_cassette("nfl good past game boxscore request") do
      request = Sportradar::Api::Nfl.new.game_boxscore(simulation_game_id)
      assert_kind_of Sportradar::Api::Nfl::Game, request
    end
  end

  def test_it_finds_an_active_simulation
    # This is a really fragile and stupid test, since it can never really find an active simulation... until it can!
    VCR.use_cassette("nfl finds active simulation") do
      simulation = Sportradar::Api::Nfl.new.active_simulation
      if simulation.is_a?(String)
        assert_kind_of Sportradar::Api::Nfl::String, simulation
      else
        assert_kind_of Sportradar::Api::Nfl::Game, simulation
      end
    end
  end


end
