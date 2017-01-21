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

    @pbp_resp = {"xmlns"=>"http://feed.elasticstats.com/schema/basketball/pbp-v2.0.xsd",
 "id"=>"3700bb52-50f0-4929-b6b0-ae0b3cbad019",
 "status"=>"closed",
 "coverage"=>"full",
 "neutral_site"=>"false",
 "home_team"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c",
 "away_team"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c",
 "scheduled"=>"2017-01-21T00:00:00+00:00",
 "duration"=>"2:03",
 "attendance"=>"18378",
 "lead_changes"=>"1",
 "times_tied"=>"1",
 "clock"=>"00:00",
 "scoring"=>{"home"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"113"}, "away"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"78"}},
  "quarter" => ["4",
 {"id"=>"39b0dad0-1cbe-44a7-a5d5-b938c56e55dd",
  "number"=>"1",
  "sequence"=>"1",
  "scoring"=>{"home"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"26"}, "away"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"18"}},
  "events"=>
   {"event"=>
     [{"id"=>"72e1469e-458d-4d5a-b6c5-fc174d50a440",
       "event_type"=>"opentip",
       "clock"=>"12:00",
       "updated"=>"2017-01-21T00:11:13+00:00",
       "description"=>"Jonas Valanciunas vs. Cody Zeller (Kyle Lowry gains possession)",
       "attribution"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "team_basket"=>"right"},
       "location"=>{"coord_x"=>"566", "coord_y"=>"294"},
       "possession"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c"},
       "on_court"=>
        {"home"=>
          {"name"=>"Hornets",
           "market"=>"Charlotte",
           "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c",
           "player"=>
            [{"full_name"=>"Nicolas Batum", "jersey_number"=>"5", "id"=>"a89ac040-715d-4057-8fc0-9d71ad06fa0a"},
             {"full_name"=>"Michael Kidd-Gilchrist", "jersey_number"=>"14", "id"=>"ea8a18e4-1341-48f1-b75d-5bbac8d789d4"},
             {"full_name"=>"Kemba Walker", "jersey_number"=>"15", "id"=>"a35ee8ed-f1db-4f7e-bb17-f823e8ee0b38"},
             {"full_name"=>"Marvin Williams", "jersey_number"=>"2", "id"=>"e17a3191-b05c-4878-8be6-21028b8ec007"},
             {"full_name"=>"Cody Zeller", "jersey_number"=>"40", "id"=>"e1ce75b8-44ce-4086-b2e1-d2e22efc86ff"}]},
         "away"=>
          {"name"=>"Raptors",
           "market"=>"Toronto",
           "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c",
           "player"=>
            [{"full_name"=>"DeMarre Carroll", "jersey_number"=>"5", "id"=>"664afb4f-3fc1-4e25-bcb8-bab2c0c3c33b"},
             {"full_name"=>"DeMar DeRozan", "jersey_number"=>"10", "id"=>"5e86a9c3-b4d0-4fe1-a551-acd83e5d60eb"},
             {"full_name"=>"Kyle Lowry", "jersey_number"=>"7", "id"=>"8c090758-6baa-468d-82fd-d47e17d5091b"},
             {"full_name"=>"Norman Powell", "jersey_number"=>"24", "id"=>"e1e4c26d-ab5c-4bd7-886a-812854466bb8"},
             {"full_name"=>"Jonas Valanciunas", "jersey_number"=>"17", "id"=>"c8788ad2-89f7-4ec9-a22b-dcaf6190889b"}]}}}]}}]}

    @game = Sportradar::Api::Basketball::Nba::Game.new(@attrs)

  end

  def test_nba_game_initializes
    assert [:id, :scheduled, :venue, :broadcast].all? { |e| @game.send(e) }
  end

  def test_nba_game_has_score
    assert_equal @game.score, { "583ec97e-fb46-11e1-82cb-f4ce4684ea4c" => 113, "583ecda6-fb46-11e1-82cb-f4ce4684ea4c" => 78 }
  end

  def test_nba_game_status_helpers
    assert @game.finished?
    assert @game.closed?
    refute @game.started?
    refute @game.future?
  end
  def test_nba_game_pbp
    @game.ingest_pbp(@pbp_resp)
    assert_equal 4, @game.quarter
    assert_equal 1, @game.quarters.size
    assert_equal 1, @game.plays.size
  end


end
