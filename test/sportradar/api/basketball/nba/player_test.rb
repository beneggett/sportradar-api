require 'test_helper'

class Sportradar::Api::Basketball::Nba::PlayerTest < Minitest::Test

  def setup
    @attrs = {"id"=>"14dee36c-97c6-4668-8f4e-2833967e6ada",
              "status"=>"ACT",
              "full_name"=>"Danuel House",
              "first_name"=>"Danuel",
              "last_name"=>"House",
              "abbr_name"=>"D.House",
              "height"=>"79",
              "weight"=>"215",
              "position"=>"F",
              "primary_position"=>"SF",
              "jersey_number"=>"4",
              "experience"=>"0",
              "college"=>"Texas A&M",
              "birth_place"=>"Fresno, TX, USA",
              "birthdate"=>"1993-06-07",
              "updated"=>"2016-10-21T14:39:43+00:00",
              "__content__"=>"\n    "}

    @data_object = Sportradar::Api::Basketball::Nba::Player.new(@attrs)
  end

  def test_basketball_nba_player_initializes
    assert [:full_name, :position, :birth_date, :birth_place, :college].all? { |e| @data_object.send(e) }
  end

  def test_basketball_nba_player_has_name
    refute_nil @data_object.name
  end

  def test_basketball_nba_player_has_age
    dob = Date.new(*@attrs['birthdate'].split('-').map(&:to_i))
    actual_age = Time.now.year - dob.year - ((Time.now.month > dob.month || (Time.now.month == dob.month && Time.now.day >= dob.day)) ? 0 : 1)
    assert_equal actual_age, @data_object.age
  end

end
