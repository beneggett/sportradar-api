require 'test_helper'

class Sportradar::Api::Nfl::SeasonTest < Minitest::Test

  def setup
    @attrs = {"id"=>"49037b4f-71c4-4e4d-8963-4f9b83e0b4bc", "year"=>"2016", "type"=>"REG", "name"=>"REG", "week"=> [{"id"=>"fca6b835-3977-4979-8a74-4d3f46e3be24", "sequence"=>"1", "title"=>"1", "game"=> [{"id"=>"28290722-4ceb-4a4c-a4e5-1f9bec7283b3", "status"=>"closed", "reference"=>"56905", "number"=>"5", "scheduled"=>"2016-09-11T17:00:00+00:00", "attendance"=>"63179", "utc_offset"=>"-5", "entry_mode"=>"INGEST", "weather"=>"Temp: 90 F, Humidity: 55%, Wind: N 3 mph", "venue"=> {"id"=>"4c5c036d-dd3d-4183-b595-71a43a97560f", "name"=>"EverBank Field", "city"=>"Jacksonville", "state"=>"FL", "country"=>"USA", "zip"=>"32202", "address"=>"One EverBank Field Drive", "capacity"=>"67246", "surface"=>"turf", "roof_type"=>"outdoor"}, "home"=> {"name"=>"Jacksonville Jaguars", "alias"=>"JAC", "game_number"=>"1", "id"=>"f7ddd7fa-0bae-4f90-bc8e-669e4d6cf2de"}, "away"=>{"name"=>"Green Bay Packers", "alias"=>"GB", "game_number"=>"1", "id"=>"a20471b4-a8d9-40c7-95ad-90cc30e46932"}, "broadcast"=>{"network"=>"FOX"}}, {"id"=>"3b1521d9-ec2c-48e9-b695-c493e65470b1", "status"=>"closed", "reference"=>"56910", "number"=>"10", "scheduled"=>"2016-09-11T17:00:00+00:00", "attendance"=>"63816", "utc_offset"=>"-6", "entry_mode"=>"INGEST", "weather"=>"Sunny Temp: 76 F, Humidity: 47%, Wind: East 5 mph", "venue"=> {"id"=>"5295c1b7-c85c-49cb-9569-1707c65324e5", "name"=>"Nissan Stadium", "city"=>"Nashville", "state"=>"TN", "country"=>"USA", "zip"=>"37213", "address"=>"One Titans Way", "capacity"=>"69143", "surface"=>"turf", "roof_type"=>"outdoor"}, "home"=>{"name"=>"Tennessee Titans", "alias"=>"TEN", "game_number"=>"1", "id"=>"d26a1ca5-722d-4274-8f97-c92e49c96315"}, "away"=> {"name"=>"Minnesota Vikings", "alias"=>"MIN", "game_number"=>"1", "id"=>"33405046-04ee-4058-a950-d606f8c30852"}, "broadcast"=>{"network"=>"FOX"} }] }]}

  end

  def test_it_initializes_an_nfl_season
    data_object = Sportradar::Api::Nfl::Season.new(@attrs)
    assert [:id, :weeks, :year, :type, :name].all? { |e| data_object.attributes.include?(e) }
  end

end
