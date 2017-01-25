require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::PlayerTest < Minitest::Test

  def setup
    @response = {"id"=>"41f66d58-0602-4e11-b0e6-75814aeaa38e",
                 "status"=>"ACT",
                 "full_name"=>"Allonzo Trier",
                 "first_name"=>"Allonzo",
                 "last_name"=>"Trier",
                 "abbr_name"=>"A.Trier",
                 "height"=>"77",
                 "weight"=>"205",
                 "position"=>"G",
                 "primary_position"=>"NA",
                 "jersey_number"=>"35",
                 "experience"=>"SO",
                 "birth_place"=>"Seattle, WA, USA",
                 "updated"=>"2016-09-08T21:38:20+00:00",
                 "__content__"=>"\n    "}

    @player = Sportradar::Api::Basketball::Ncaamb::Player.new(@response)
  end

  def test_basketball_ncaamb_player_initializes
    assert [:jersey, :full_name, :position, :birth_place].all? { |e| @player.send(e) }
  end

  def test_basketball_ncaamb_player_has_name
    assert_equal 'Allonzo Trier', @player.name
  end

end
