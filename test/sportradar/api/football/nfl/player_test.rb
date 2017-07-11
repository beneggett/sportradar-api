require 'test_helper'

class Sportradar::Api::Football::Nfl::PlayerTest < Minitest::Test

  def setup
    data = {"name"=>"Russell Wilson",
     "jersey"=>"3",
     "last_name"=>"Wilson",
     "first_name"=>"Russell",
     "abbr_name"=>"R.Wilson",
     "preferred_name"=>"Russell",
     "birth_date"=>"1988-11-29",
     "weight"=>206.0,
     "height"=>71,
     "id"=>"409d4cac-ee90-4470-9710-ebe671678339",
     "position"=>"QB",
     "birth_place"=>"Richmond, VA, USA",
     "high_school"=>"Collegiate (VA)",
     "college"=>"Wisconsin",
     "college_conf"=>"Big Ten Conference",
     "rookie_year"=>2012,
     "status"=>"A01",
     "draft"=>{"year"=>2012, "round"=>3, "number"=>75, "team"=>{"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"}},
     "references"=>[{"id"=>"00-0029263", "origin"=>"gsis"}, {"id"=>"38605", "origin"=>"nflx"}]}
    @player = Sportradar::Api::Football::Nfl::Player.new(data)
  end

  def test_player_has_display_name
    assert_equal 'Russell Wilson', @player.display_name
  end

end
