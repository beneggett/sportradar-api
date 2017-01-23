require 'test_helper'

class Sportradar::Api::Basketball::Nba::GameSummaryTest < Minitest::Test

  def setup
    @attrs = { "id" => "3700bb52-50f0-4929-b6b0-ae0b3cbad019" }
    @game = Sportradar::Api::Basketball::Nba::Game.new(@attrs)
    VCR.use_cassette("nba/game/summary_regulation") do
      @game.get_summary
    end
  end

  def test_nba_game_summary
    assert_equal 4, @game.quarter
    assert @game.closed?
  end

  def test_nba_game_summary_quarter_scoring
    assert_equal 18, @game.scoring.dig(1, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 26, @game.scoring.dig(1, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 30, @game.scoring.dig(2, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 29, @game.scoring.dig(2, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 15, @game.scoring.dig(3, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 33, @game.scoring.dig(3, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 15, @game.scoring.dig(4, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c")
    assert_equal 25, @game.scoring.dig(4, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c")
  end

  def test_nba_game_summary_team_stats
    assert_includes @game.team_stats.keys, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c"
    assert_includes @game.team_stats.keys, "583ec97e-fb46-11e1-82cb-f4ce4684ea4c"
    
    assert_equal 29, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_made').to_i
    assert_equal 40, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_made').to_i
    assert_equal 86, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_att').to_i
    assert_equal 80, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_att').to_i
    assert_equal 33.7, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_pct').to_f
    assert_equal 50.0, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'field_goals_pct').to_f
    assert_equal 7, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_made').to_i
    assert_equal 12, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_made').to_i
    assert_equal 30, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_att').to_i
    assert_equal 25, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_att').to_i
    assert_equal 23.3, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_pct').to_f
    assert_equal 48.0, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'three_points_pct').to_f
    assert_equal 13, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_made').to_i
    assert_equal 21, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_made').to_i
    assert_equal 14, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_att').to_i
    assert_equal 25, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_att').to_i
    assert_equal 92.9, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_pct').to_f
    assert_equal 84.0, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'free_throws_pct').to_f
    assert_equal 33, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'rebounds').to_i
    assert_equal 51, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'rebounds').to_i
    assert_equal 8, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'offensive_rebounds').to_i
    assert_equal 11, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'offensive_rebounds').to_i
    assert_equal 25, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'defensive_rebounds').to_i
    assert_equal 40, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'defensive_rebounds').to_i
    assert_equal 10, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'assists').to_i
    assert_equal 24, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'assists').to_i
    assert_equal 7, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'steals').to_i
    assert_equal 9, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'steals').to_i
    assert_equal 6, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'blocks').to_i
    assert_equal 4, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'blocks').to_i
    assert_equal 12, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'turnovers').to_i
    assert_equal 14, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'turnovers').to_i
    assert_equal 14, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'points_off_turnovers').to_i
    assert_equal 19, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'points_off_turnovers').to_i
    assert_equal 16, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'fast_break_pts').to_i
    assert_equal 12, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'fast_break_pts').to_i
    assert_equal 32, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'paint_pts').to_i
    assert_equal 42, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'paint_pts').to_i
    assert_equal 10, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'second_chance_pts').to_i
    assert_equal 12, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'second_chance_pts').to_i
    assert_equal 20, @game.team_stats.dig("583ecda6-fb46-11e1-82cb-f4ce4684ea4c", 'personal_fouls').to_i
    assert_equal 13, @game.team_stats.dig("583ec97e-fb46-11e1-82cb-f4ce4684ea4c", 'personal_fouls').to_i
  end

end
