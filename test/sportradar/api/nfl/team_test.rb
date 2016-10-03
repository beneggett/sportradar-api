require 'test_helper'

class Sportradar::Api::Nfl::TeamTest < Minitest::Test

  def setup
    @attrs = {"name"=>"Patriots", "wins"=> "3", "losses" => "1", "ties" => "0", "market"=>"New England", "alias"=>"NE", "id"=>"97354895-8c77-4fd4-a860-32e62ea7382a", "franchise"=> {"id"=>"c95b688d-810a-4323-9dad-fa3696ed8a37", "name"=>"Patriots", "alias"=>"NE", "references"=>{"reference"=>{"id"=>"17", "origin"=>"gsis"}}}, "venue"=> {"id"=>"e43310b1-cb82-4df9-8be5-e9b39637031b", "name"=>"Gillette Stadium", "city"=>"Foxborough", "state"=>"MA", "country"=>"USA", "zip"=>"02035", "address"=>"One Patriot Place", "capacity"=>"68756", "surface"=>"artificial", "roof_type"=>"outdoor"}, "hierarchy"=> {"division"=> {"id"=>"b95cd27d-d631-4fe1-bc05-0ae47fc0b14b", "name"=>"AFC East", "alias"=>"AFC_EAST"}, "conference"=> {"id"=>"1bdefe12-6cb2-4d6a-b208-b04602ae79c3", "name"=>"AFC", "alias"=>"AFC"}}, "references"=>{"reference"=>{"id"=>"NE", "origin"=>"gsis"}}, "coaches"=> {"coach"=> [{"id"=>"1a10c6e6-5e9c-49cb-b1ba-cb0e9f564a0e", "full_name"=>"Josh McDaniels", "first_name"=>"Josh", "last_name"=>"McDaniels", "position"=>"Offensive Coordinator"}, {"id"=>"25fd8a96-446e-4a72-be98-91052a05a856", "full_name"=>"Bill Belichick", "first_name"=>"Bill", "last_name"=>"Belichick", "position"=>"Head Coach"}, {"id"=>"a5b8bdfd-9097-4357-b31c-d41462de89c9", "full_name"=>"Matt Patricia", "first_name"=>"Matt", "last_name"=>"Patricia", "position"=>"Defensive Coordinator"}]}, "players"=> {"player"=> [{"name"=>"Martellus Bennett", "jersey"=>"88", "last_name"=>"Bennett", "first_name"=>"Martellus", "abbr_name"=>"M.Bennett", "preferred_name"=>"Martellus", "birth_date"=>"1987-03-10", "weight"=>"273.0", "height"=>"78", "status"=>"A01", "id"=>"0ca741f8-58bd-4933-9d5c-0e04de3f4cff", "position"=>"TE", "birth_place"=>"Houston, TX, USA", "high_school"=>"Alief Taylor (TX)", "college"=>"Texas A&M", "college_conf"=>"Big Twelve Conference", "rookie_year"=>"2008", "draft"=> {"year"=>"2008", "round"=>"2", "number"=>"61", "team"=> {"name"=>"Cowboys", "market"=>"Dallas", "alias"=>"DAL", "id"=>"e627eec7-bbae-4fa4-8e73-8e1d6bc5c060"}}, "references"=> {"reference"=> [{"id"=>"33142", "origin"=>"nflx"}, {"id"=>"00-0026201", "origin"=>"gsis"}]}}, {"name"=>"Jordan Richards", "jersey"=>"37", "last_name"=>"Richards", "first_name"=>"Jordan", "abbr_name"=>"J.Richards", "preferred_name"=>"Jordan", "birth_date"=>"1993-01-21", "weight"=>"210.0", "height"=>"71", "status"=>"A01", "id"=>"13f716fb-7249-4b0a-9858-8af8cb83f78b", "position"=>"SS", "birth_place"=>"Folsom, CA, USA", "high_school"=>"Folsom High School", "college"=>"Stanford", "college_conf"=>"Pacific Twelve Conference", "rookie_year"=>"2015", "draft"=> {"year"=>"2015", "round"=>"2", "number"=>"64", "team"=> {"name"=>"Patriots", "market"=>"New England", "alias"=>"NE", "id"=>"97354895-8c77-4fd4-a860-32e62ea7382a"}}, "references"=> {"reference"=> [{"id"=>"42407", "origin"=>"nflx"}, {"id"=>"00-0031559", "origin"=>"gsis"}]}} ] }}

    @data_object = Sportradar::Api::Nfl::Team.new(@attrs)
  end

  def test_nfl_team_initializes
    assert [:id, :name, :alias, :market].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_team_has_full_name
    assert_equal [@data_object.market, @data_object.name].join(' '), @data_object.full_name
  end

  def test_nfl_team_has_record
    assert_equal "#{@data_object.wins}-#{@data_object.losses}", @data_object.record
  end

end
