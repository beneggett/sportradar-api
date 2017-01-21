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
         [
         {"id"=>"70045c51-9ffc-4417-9b0f-2020f46dac98",
            "event_type"=>"shootingfoul",
            "clock"=>"10:25",
            "updated"=>"2017-01-21T00:12:49+00:00",
            "description"=>"Nicolas Batum shooting foul (DeMar DeRozan draws the foul)",
            "attribution"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c", "team_basket"=>"left"},
            "location"=>{"coord_x"=>"866", "coord_y"=>"438"},
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
                  {"full_name"=>"Jonas Valanciunas", "jersey_number"=>"17", "id"=>"c8788ad2-89f7-4ec9-a22b-dcaf6190889b"}]}},
            "statistics"=>{"personalfoul"=>{"team"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c"}, "player"=>{"full_name"=>"Nicolas Batum", "jersey_number"=>"5", "id"=>"a89ac040-715d-4057-8fc0-9d71ad06fa0a"}}}}]}},
        {"id"=>"41c89c5c-ded9-4bfb-99ba-228b5fe899df",
         "number"=>"2",
         "sequence"=>"2",
         "scoring"=>{"home"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"29"}, "away"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "points"=>"30"}},
         "events"=>
          {"event"=>
            [
             {"id"=>"673832dd-3844-4394-a8df-f6d738a375a2",
              "event_type"=>"personalfoul",
              "clock"=>"11:26",
              "updated"=>"2017-01-21T00:37:21+00:00",
              "description"=>"Jared Sullinger personal foul (Roy Hibbert draws the foul)",
              "attribution"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c", "team_basket"=>"right"},
              "location"=>{"coord_x"=>"133", "coord_y"=>"355"},
              "possession"=>{"name"=>"Hornets", "market"=>"Charlotte", "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c"},
              "on_court"=>
               {"home"=>
                 {"name"=>"Hornets",
                  "market"=>"Charlotte",
                  "id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c",
                  "player"=>
                   [{"full_name"=>"Ramon Sessions", "jersey_number"=>"7", "id"=>"91ac13f8-e8d3-4902-b451-83ff32d2cf28"},
                    {"full_name"=>"Roy Hibbert", "jersey_number"=>"55", "id"=>"20f69728-18f2-4917-aabf-9893c3bff3be"},
                    {"full_name"=>"Nicolas Batum", "jersey_number"=>"5", "id"=>"a89ac040-715d-4057-8fc0-9d71ad06fa0a"},
                    {"full_name"=>"Marco Belinelli", "jersey_number"=>"21", "id"=>"385f6a05-7dfb-4fc8-afed-b6a4f141100c"},
                    {"full_name"=>"Marvin Williams", "jersey_number"=>"2", "id"=>"e17a3191-b05c-4878-8be6-21028b8ec007"}]},
                "away"=>
                 {"name"=>"Raptors",
                  "market"=>"Toronto",
                  "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c",
                  "player"=>
                   [{"full_name"=>"Jared Sullinger", "jersey_number"=>"0", "id"=>"cdda9628-563e-4d3e-a660-d9665aaa94a3"},
                    {"full_name"=>"Cory Joseph", "jersey_number"=>"6", "id"=>"5769354c-0661-4ac7-86e5-3fd51506df36"},
                    {"full_name"=>"Kyle Lowry", "jersey_number"=>"7", "id"=>"8c090758-6baa-468d-82fd-d47e17d5091b"},
                    {"full_name"=>"Terrence Ross", "jersey_number"=>"31", "id"=>"b7d0fa52-b5ca-4465-9bbb-3ec9b6b7b536"},
                    {"full_name"=>"Pascal Siakam", "jersey_number"=>"43", "id"=>"3df1db1d-6596-489e-8e26-80f60fd9b1f4"}]}},
              "statistics"=>{"personalfoul"=>{"team"=>{"name"=>"Raptors", "market"=>"Toronto", "id"=>"583ecda6-fb46-11e1-82cb-f4ce4684ea4c"}, "player"=>{"full_name"=>"Jared Sullinger", "jersey_number"=>"0", "id"=>"cdda9628-563e-4d3e-a660-d9665aaa94a3"}}}},
                ]}},
                ]}

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
    assert_equal 2, @game.quarters.size
    assert_equal 2, @game.plays.size
  end
  def test_nba_game_play_timing
    @game.ingest_pbp(@pbp_resp)
    assert_equal 95, @game.plays.first.game_seconds
    assert_equal 1, @game.plays.first.quarter
    assert_equal 754, @game.plays.last.game_seconds
    assert_equal 2, @game.plays.last.quarter
  end


end
