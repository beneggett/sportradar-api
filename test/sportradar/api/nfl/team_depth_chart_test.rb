require 'test_helper'

class Sportradar::Api::Nfl::TeamDepthChartTest < Minitest::Test

  def setup
    data = {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "id"=>"de760528-1dc0-416a-a978-b510d20692ff", "offense" => {"position"=> [{"name"=>"LT", "player"=> [{"name"=>"Edwin Veldheer", "jersey"=>"68", "reference"=>"00-0027674", "id"=>"52366445-a41d-4b7c-bd42-1ea4cb940695", "position"=>"T", "depth"=>"1"}, {"name"=>"John Wetzel", "jersey"=>"73", "reference"=>"00-0029762", "id"=>"543a98a6-42fb-4fbc-9899-f0ee59b1a114", "position"=>"T", "depth"=>"2"}]}]},  "special_teams" => {"position"=> [{"name"=>"PR", "player"=> [{"name"=>"Andre Ellington", "jersey"=>"38", "reference"=>"00-0030287", "id"=>"1ce7bca8-68f0-47ba-9484-5baf57dd75e8", "position"=>"RB", "depth"=>"1"}, {"name"=>"Jamarcus Nelson", "jersey"=>"14", "reference"=>"00-0032112", "id"=>"617269c1-88b3-45a6-b4a8-b2806a0cdaea", "position"=>"WR", "depth"=>"2"}, {"name"=>"Patrick Peterson", "jersey"=>"21", "reference"=>"00-0027943", "id"=>"9f3b934e-52d6-4e16-ae92-d3e60be10493", "position"=>"CB", "depth"=>"3"}]}]},"defense"=> {"position"=> [{"name"=>"$LB", "player"=> [{"name"=>"Deone Bucannon", "jersey"=>"20", "id"=>"a1902bda-47bc-4436-9165-2d79620e4030", "position"=>"ILB", "depth"=>"1"}, {"name"=>"Gabriel Martin", "jersey"=>"50", "id"=>"7595ead0-d80a-4dc5-bbd4-b2577d566608", "position"=>"ILB", "depth"=>"2"}]}, {"name"=>"FS", "player"=> [{"name"=>"Tyrann Mathieu", "jersey"=>"32", "id"=>"8c8b7d6e-6ed8-4a10-8ae9-b50300bd766b", "position"=>"FS", "depth"=>"1"}, {"name"=>"Dayario Swearinger", "jersey"=>"36", "id"=>"5486420b-b40c-4e7c-ab47-9d70b1673c3b", "position"=>"FS", "depth"=>"2"}]}]}}

    season_attrs = {"id"=>"49037b4f-71c4-4e4d-8963-4f9b83e0b4bc", "year"=>"2016", "type"=>"REG", "name"=>"REG", "week"=> [{"id"=>"fca6b835-3977-4979-8a74-4d3f46e3be24", "sequence"=>"1", "title"=>"1", "game"=> [{"id"=>"28290722-4ceb-4a4c-a4e5-1f9bec7283b3", "status"=>"closed", "reference"=>"56905", "number"=>"5", "scheduled"=>"2016-09-11T17:00:00+00:00", "attendance"=>"63179", "utc_offset"=>"-5", "entry_mode"=>"INGEST", "weather"=>"Temp: 90 F, Humidity: 55%, Wind: N 3 mph", "venue"=> {"id"=>"4c5c036d-dd3d-4183-b595-71a43a97560f", "name"=>"EverBank Field", "city"=>"Jacksonville", "state"=>"FL", "country"=>"USA", "zip"=>"32202", "address"=>"One EverBank Field Drive", "capacity"=>"67246", "surface"=>"turf", "roof_type"=>"outdoor"}, "home"=> {"name"=>"Jacksonville Jaguars", "alias"=>"JAC", "game_number"=>"1", "id"=>"f7ddd7fa-0bae-4f90-bc8e-669e4d6cf2de"}, "away"=>{"name"=>"Green Bay Packers", "alias"=>"GB", "game_number"=>"1", "id"=>"a20471b4-a8d9-40c7-95ad-90cc30e46932"}, "broadcast"=>{"network"=>"FOX"}}, {"id"=>"3b1521d9-ec2c-48e9-b695-c493e65470b1", "status"=>"closed", "reference"=>"56910", "number"=>"10", "scheduled"=>"2016-09-11T17:00:00+00:00", "attendance"=>"63816", "utc_offset"=>"-6", "entry_mode"=>"INGEST", "weather"=>"Sunny Temp: 76 F, Humidity: 47%, Wind: East 5 mph", "venue"=> {"id"=>"5295c1b7-c85c-49cb-9569-1707c65324e5", "name"=>"Nissan Stadium", "city"=>"Nashville", "state"=>"TN", "country"=>"USA", "zip"=>"37213", "address"=>"One Titans Way", "capacity"=>"69143", "surface"=>"turf", "roof_type"=>"outdoor"}, "home"=>{"name"=>"Tennessee Titans", "alias"=>"TEN", "game_number"=>"1", "id"=>"d26a1ca5-722d-4274-8f97-c92e49c96315"}, "away"=> {"name"=>"Minnesota Vikings", "alias"=>"MIN", "game_number"=>"1", "id"=>"33405046-04ee-4058-a950-d606f8c30852"}, "broadcast"=>{"network"=>"FOX"} }] }]}
    season =  Sportradar::Api::Nfl::Season.new(season_attrs)

    @data_object = Sportradar::Api::Nfl::TeamDepthChart.new(data, season)
  end

  def test_nfl_depth_chart_initialization
    assert [:season, :team_id].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_depth_chart_each
    # not really sure what to test here
    # binding.pry
    @data_object.each do |key, values|
      assert_kind_of Symbol, key
      assert_kind_of Sportradar::Api::Nfl::DepthChart, values
    end
  end


end
