require 'test_helper'

class Sportradar::Api::Nfl::PlayerTest < Minitest::Test

  def setup
    @attrs = {"name"=>"Preston Smith", "jersey"=>"94", "last_name"=>"Smith", "first_name"=>"Preston", "abbr_name"=>"P.Smith", "preferred_name"=>"Billy", "birth_date"=>"1992-11-17", "weight"=>"271.0", "height"=>"77", "id"=>"ede260be-5ae6-4a06-887b-e4a130932705", "position"=>"OLB", "birth_place"=>"Stone Mountain, GA, USA", "high_school"=>"Stephenson", "college"=>"Mississippi State", "college_conf"=>"Southeastern Conference", "rookie_year"=>"2015", "status"=>"A01", "team"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624"}, "draft"=> {"year"=>"2015", "round"=>"2", "number"=>"38", "team"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624"}}, "season"=> [{"id"=>"279aae01-091e-4757-af17-0a3f36fc9592", "year"=>"2015", "type"=>"PST", "name"=>"PST", "team"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624", "statistics"=> {"games_played"=>"1", "defense"=> {"tackles"=>"2", "assists"=>"1", "combined"=>"3", "sacks"=>"1.0", "sack_yards"=>"5.0", "missed_tackles"=>"2"}}}}, {"id"=>"46aa2ca3-c2fc-455d-8256-1f7893a87113", "year"=>"2015", "type"=>"REG", "name"=>"REG", "team"=> {"name"=>"Redskins", "market"=>"Washington", "alias"=>"WAS", "id"=>"22052ff7-c065-42ee-bc8f-c4691c50e624", "statistics"=> {"games_played"=>"16", "games_started"=>"2", "fumbles"=> {"opp_rec"=>"1", "forced_fumbles"=>"3", "defense"=> {"tackles"=>"20", "assists"=>"10", "combined"=>"30", "sacks"=>"8.0", "sack_yards"=>"77.0", "passes_defended"=>"4", "forced_fumbles"=>"2", "fumble_recoveries"=>"1", "qb_hits"=>"10", "tloss"=>"6.0", "tloss_yards"=>"39.0", "sp_tackles"=>"4", "sp_assists"=>"1", "sp_forced_fumbles"=>"1", "missed_tackles"=>"3"}}}} }] }
    @data_object = Sportradar::Api::Nfl::Player.new(@attrs)
  end

  def test_nfl_player_initializes
    assert [:position, :birth_date, :birth_place, :college, :seasons].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_player_has_name
    refute_nil @data_object.name
  end

  def test_nfl_player_name_is_preferred
    assert_equal 'Billy Smith', @data_object.name
  end

  def test_nfl_player_has_age
    dob = Date.new(*@attrs['birth_date'].split('-').map(&:to_i))
    actual_age = Time.now.year - dob.year - ((Time.now.month > dob.month || (Time.now.month == dob.month && Time.now.day >= dob.day)) ? 0 : 1)
    assert_equal actual_age, @data_object.age
  end

end
