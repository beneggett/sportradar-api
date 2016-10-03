require 'test_helper'

class Sportradar::Api::Nfl::GameTest < Minitest::Test

  def setup
    @attrs = {"id"=>"0141a0a5-13e5-4b28-b19f-0c3923aaef6e", "status"=>"closed", "number"=>"8", "scheduled"=>"2015-09-13T17:02:41+00:00", "attendance"=>"76512", "utc_offset"=>"-5", "entry_mode"=>"INGEST", "weather"=>"Partly Cloudy Temp: 69 F, Humidity: 58%, Wind: NW 10 mph", "clock"=>"00:00", "summary"=> {"season"=> {"id"=>"46aa2ca3-c2fc-455d-8256-1f7893a87113", "year"=>"2015", "type"=>"REG", "name"=>"REG"}, "week"=>{"id"=>"581edacd-e641-43d6-9e69-76b29a306643", "sequence"=>"1", "title"=>"1"}, "venue"=> {"id"=>"7c11bb2d-4a53-4842-b842-0f1c63ed78e9", "name"=>"FedExField", "city"=>"Landover", "state"=>"MD", "country"=>"USA", "zip"=>"20785", "address"=>"1600 FedEx Way", "capacity"=>"83000", "surface"=>"turf", "roof_type"=>"outdoor"}, "home"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "used_timeouts"=>"3", "remaining_timeouts"=>"0", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624", "points"=>"10"}, "away"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "used_timeouts"=>"1", "remaining_timeouts"=>"2", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06", "points"=>"17"} }, "situation"=> {"clock"=>"00:00", "down"=>"2", "yfd"=>"11", "possession"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06"}, "location"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06", "yardline"=>"45"}}, "quarter"=> ["1", {"id"=>"fd31368b-a159-4f56-a022-afc691e34755", "number"=>"1", "sequence"=>"1", "play_by_play"=> {"event"=> {"id"=>"84929b50-5c73-475d-8a3d-43e024860178", "sequence"=>"1.0", "reference"=>"1", "clock"=>"00:00", "type"=>"setup", "description"=>"GAME", "alt_description"=>"GAME"}, "drive"=> [{"id"=>"a956d9cb-d8ab-408c-91fc-442f06e338ff", "sequence"=>"1", "start_reason"=>"Kickoff", "end_reason"=>"Field Goal", "play_count"=>"12", "duration"=>"7:21", "first_downs"=>"4", "gain"=>"54", "penalty_yards"=>"-1", "scoring_drive"=>"true", "play"=> [{"id"=>"9de4c5df-5e94-4fe2-b646-ba1dca0a1afd", "sequence"=>"63.0", "reference"=>"63", "clock"=>"15:00", "home_points"=>"0", "away_points"=>"0", "type"=>"kickoff", "play_clock"=>"12", "wall_clock"=>"2015-09-13T17:02:41+00:00", "start_situation"=> {"clock"=>"15:00", "down"=>"0", "yfd"=>"0", "possession"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "reference"=>"4958", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06"}, "location"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "reference"=>"4958", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06", "yardline"=>"35"}}, "end_situation"=> {"clock"=>"15:00", "down"=>"1", "yfd"=>"10", "possession"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "reference"=>"4971", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624"}, "location"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "reference"=>"4971", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624", "yardline"=>"20"}}, "description"=>"3-A.Franks kicks 65 yards from MIA 35 to end zone, Touchback.", "alt_description"=>"A.Franks kicks 65 yards from MIA 35 to end zone, Touchback.", "statistics"=> {"kick"=> {"attempt"=>"1", "yards"=>"65", "gross_yards"=>"74", "touchback"=>"1", "team"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "reference"=>"4958", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06"}, "player"=> {"name"=>"Andrew Franks", "jersey"=>"03", "reference"=>"00-0031718", "id"=>"59da7aea-f21a-43c5-b0bf-2d1e8b19da80", "position"=>"K"}}, "return"=> {"touchback"=>"1", "category"=>"kick_return", "team"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "reference"=>"4971", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624"}}}} ] } ] }, "scoring"=> {"home"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624", "points"=>"3"}, "away"=> {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06", "points"=>"0"}} } ] }
    @data_object = Sportradar::Api::Nfl::Game.new(@attrs)
  end

  def test_nfl_game_initializes
    assert [:id, :scheduled, :week, :season, :home, :away, :summary].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_game_shows_current_score
    assert_equal "#{@data_object.summary.home.points}-#{@data_object.summary.away.points}",  @data_object.current_score
  end

  def test_nfl_game_maps_drives
    assert_equal  1, @data_object.drives.count
    assert_kind_of  Sportradar::Api::Nfl::Drive, @data_object.drives.sample
  end

  def test_nfl_game_maps_plays
    assert_equal  1, @data_object.plays.count
    assert_kind_of  Sportradar::Api::Nfl::Play, @data_object.plays.sample
  end


  def test_nfl_game_full_name
    assert_equal "#{@data_object.away.full_name} vs #{@data_object.home.full_name}", @data_object.full_name
  end

  def test_nfl_game_name
    assert_equal "#{@data_object.away.name} vs #{@data_object.home.name}", @data_object.name
  end

end
