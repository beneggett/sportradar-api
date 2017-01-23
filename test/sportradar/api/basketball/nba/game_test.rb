require 'test_helper'

class Sportradar::Api::Basketball::Nba::GameTest < Minitest::Test

  def setup
    @attrs = { "id"=>"3700bb52-50f0-4929-b6b0-ae0b3cbad019",
               "status"=>"closed",
               "coverage"=>"full",
               "home_team"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c",
               "away_team"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c",
               "scheduled"=>"2017-01-21T00:00:00+00:00",
               "home_points"=>"113",
               "away_points"=>"78",
               "venue"=>{"id"=>"a380f011-6e5d-5430-9f37-209e1e8a9b6f", "name"=>"Spectrum Center", "capacity"=>"19077", "address"=>"330 E. Trade St.", "city"=>"Charlotte", "state"=>"NC", "zip"=>"28202", "country"=>"USA"},
               "home"=>{"name"=>"Charlotte Hornets", "alias"=>"CHA", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c", "__content__"=>"\n        "},
               "away"=>{"name"=>"Toronto Raptors", "alias"=>"TOR", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "__content__"=>"\n        "},
               "broadcast"=>{"network"=>"FS-SE", "satellite"=>"649-1"}}

    @game = Sportradar::Api::Basketball::Nba::Game.new(@attrs)

  end

  def test_nba_game_initializes
    assert [:id, :scheduled, :venue, :broadcast].all? { |e| @game.send(e) }
  end

  def test_nba_game_has_score
    assert_equal ({ "583ec97e-fb46-11e1-82cb-f4ce4684ea4c" => 113, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c" => 78 }), @game.score
  end

  def test_nba_game_status_helpers
    assert @game.finished?
    assert @game.closed?
    refute @game.started?
    refute @game.future?
    @game.status = 'scheduled'
    assert @game.future?
  end

end
