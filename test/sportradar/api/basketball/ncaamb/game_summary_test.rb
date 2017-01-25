require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::GameSummaryTest < Minitest::Test

  def setup
    # ESPN boxscore: http://www.espn.com/mens-college-basketball/boxscore?gameId=400915635
    game_id = "29111b80-992d-4e32-a88d-220fb4bd3121"
    @game = Sportradar::Api::Basketball::Ncaamb::Game.new('id' => game_id)
    VCR.use_cassette("ncaamb/game/summary_regulation") do
      @game.get_summary
      @home_id = @game.home_id
      @away_id = @game.away_id
    end
  end

  def test_ncaamb_game_summary
    assert_equal 2, @game.half
    assert @game.closed?
  end

  def test_ncaamb_game_summary_scoring
    assert_equal 48, @game.scoring.dig(1, @away_id)
    assert_equal 37, @game.scoring.dig(1, @home_id)
    assert_equal 48, @game.scoring.dig(2, @away_id)
    assert_equal 48, @game.scoring.dig(2, @home_id)
  end

  def test_ncaamb_game_summary_team_stats
    assert_includes @game.team_stats.keys, @away_id
    assert_includes @game.team_stats.keys, @home_id


    assert_equal 32, @game.team_stats.dig(@home_id, "field_goals_made").to_i
    assert_equal 71, @game.team_stats.dig(@home_id, "field_goals_att").to_i
    assert_equal 45.1, @game.team_stats.dig(@home_id, "field_goals_pct").to_f
    assert_equal 10, @game.team_stats.dig(@home_id, "three_points_made").to_i
    assert_equal 31, @game.team_stats.dig(@home_id, "three_points_att").to_i
    assert_equal 32.3, @game.team_stats.dig(@home_id, "three_points_pct").to_f
    assert_equal 22, @game.team_stats.dig(@home_id, "two_points_made").to_i
    assert_equal 40, @game.team_stats.dig(@home_id, "two_points_att").to_i
    assert_equal 55.0, @game.team_stats.dig(@home_id, "two_points_pct").to_f
    assert_equal 1, @game.team_stats.dig(@home_id, "blocked_att").to_i
    assert_equal 11, @game.team_stats.dig(@home_id, "free_throws_made").to_i
    assert_equal 14, @game.team_stats.dig(@home_id, "free_throws_att").to_i
    assert_equal 78.6, @game.team_stats.dig(@home_id, "free_throws_pct").to_f
    assert_equal 9, @game.team_stats.dig(@home_id, "offensive_rebounds").to_i
    assert_equal 22, @game.team_stats.dig(@home_id, "defensive_rebounds").to_i
    assert_equal 31, @game.team_stats.dig(@home_id, "rebounds").to_i
    assert_equal 18, @game.team_stats.dig(@home_id, "assists").to_i
    assert_equal 6, @game.team_stats.dig(@home_id, "turnovers").to_i
    assert_equal 4, @game.team_stats.dig(@home_id, "steals").to_i
    assert_equal 6, @game.team_stats.dig(@home_id, "blocks").to_i
    assert_equal 3.0, @game.team_stats.dig(@home_id, "assists_turnover_ratio").to_f
    assert_equal 19, @game.team_stats.dig(@home_id, "personal_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "ejections").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "foulouts").to_i
    assert_equal 85, @game.team_stats.dig(@home_id, "points").to_i
    assert_equal 8, @game.team_stats.dig(@home_id, "fast_break_pts").to_i
    assert_equal 32, @game.team_stats.dig(@home_id, "paint_pts").to_i
    assert_equal 24, @game.team_stats.dig(@home_id, "second_chance_pts").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "team_turnovers").to_i
    assert_equal 13, @game.team_stats.dig(@home_id, "points_off_turnovers").to_i
    assert_equal 2, @game.team_stats.dig(@home_id, "team_rebounds").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "flagrant_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "player_tech_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "team_tech_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@home_id, "coach_tech_fouls").to_i

    assert_equal 34, @game.team_stats.dig(@away_id, "field_goals_made").to_i
    assert_equal 68, @game.team_stats.dig(@away_id, "field_goals_att").to_i
    assert_equal 50.0, @game.team_stats.dig(@away_id, "field_goals_pct").to_f
    assert_equal 9, @game.team_stats.dig(@away_id, "three_points_made").to_i
    assert_equal 20, @game.team_stats.dig(@away_id, "three_points_att").to_i
    assert_equal 45.0, @game.team_stats.dig(@away_id, "three_points_pct").to_f
    assert_equal 25, @game.team_stats.dig(@away_id, "two_points_made").to_i
    assert_equal 48, @game.team_stats.dig(@away_id, "two_points_att").to_i
    assert_equal 52.083, @game.team_stats.dig(@away_id, "two_points_pct").to_f
    assert_equal 6, @game.team_stats.dig(@away_id, "blocked_att").to_i
    assert_equal 19, @game.team_stats.dig(@away_id, "free_throws_made").to_i
    assert_equal 21, @game.team_stats.dig(@away_id, "free_throws_att").to_i
    assert_equal 90.5, @game.team_stats.dig(@away_id, "free_throws_pct").to_f
    assert_equal 9, @game.team_stats.dig(@away_id, "offensive_rebounds").to_i
    assert_equal 28, @game.team_stats.dig(@away_id, "defensive_rebounds").to_i
    assert_equal 37, @game.team_stats.dig(@away_id, "rebounds").to_i
    assert_equal 15, @game.team_stats.dig(@away_id, "assists").to_i
    assert_equal 7, @game.team_stats.dig(@away_id, "turnovers").to_i
    assert_equal 4, @game.team_stats.dig(@away_id, "steals").to_i
    assert_equal 1, @game.team_stats.dig(@away_id, "blocks").to_i
    assert_equal 2.14, @game.team_stats.dig(@away_id, "assists_turnover_ratio").to_f
    assert_equal 16, @game.team_stats.dig(@away_id, "personal_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "ejections").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "foulouts").to_i
    assert_equal 96, @game.team_stats.dig(@away_id, "points").to_i
    assert_equal 8, @game.team_stats.dig(@away_id, "fast_break_pts").to_i
    assert_equal 34, @game.team_stats.dig(@away_id, "paint_pts").to_i
    assert_equal 24, @game.team_stats.dig(@away_id, "second_chance_pts").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "team_turnovers").to_i
    assert_equal 12, @game.team_stats.dig(@away_id, "points_off_turnovers").to_i
    assert_equal 5, @game.team_stats.dig(@away_id, "team_rebounds").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "flagrant_fouls").to_i
    assert_equal 1, @game.team_stats.dig(@away_id, "player_tech_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "team_tech_fouls").to_i
    assert_equal 0, @game.team_stats.dig(@away_id, "coach_tech_fouls").to_i
  end

end
