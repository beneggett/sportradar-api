require 'test_helper'

class Sportradar::Api::Soccer::PlayerTest < Minitest::Test

  def setup
    @attrs = {"id"=>"2aeacd39-3f9c-42af-957e-9df8573973c4", "first_name"=>"Kyle", "last_name"=>"Beckerman", "country_code"=>"USA", "country"=>"United States", "preferred_foot"=>"R", "birthdate"=>"1982-04-23", "height_in"=>"70", "weight_lb"=>"154", "height_cm"=>"177", "weight_kg"=>"69", "tactical_position" => "6", "full_first_name"=>"Kyle Robert", "full_last_name"=>"Beckerman", "teams"=> {"team"=> [{"id"=>"b78b9f61-0697-4347-a1b6-b7685a130eb1", "name"=>"Salt Lake", "full_name"=>"Real Salt Lake", "country_code"=>"USA", "country"=>"United States", "jersey_number"=>"5", "position"=>"M", "is_player"=>"true", "is_manager"=>"false"}, {"id"=>"79a99f09-13ca-45c4-b3f0-2a61f94e0651", "name"=>"USA", "full_name"=>"USA", "country_code"=>"USA", "country"=>"United States", "jersey_number"=>"15", "position"=>"M", "is_player"=>"true", "is_manager"=>"false"}]}, "statistics"=>{"season"=>[{"year"=>"2007", "statistic"=>{"goals"=>"0", "goal_frequency"=>"0", "goal_average"=>"0.0"}}]}}
    @data_object = Sportradar::Api::Soccer::Player.new(@attrs)
  end

  def test_it_initializes_a_soccer_player

    assert [:last_name, :first_name,  :country, :country_code, :birthdate, :teams, :statistics].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_soccer_player_has_name
    assert_equal [@data_object.first_name, @data_object.last_name].join(' '), @data_object.name
  end

  def test_soccer_player_has_full_name
    assert_equal [@data_object.full_first_name, @data_object.full_last_name].join(' '), @data_object.full_name
  end

  def test_soccer_player_has_position_name
    assert_equal "Midfielder", @data_object.position_name
  end

  def test_soccer_player_has_tactical_position_name
    assert_equal "Central Midfielder", @data_object.tactical_position_name
  end

  def test_soccer_player_has_age
    assert_equal 35, @data_object.age
  end

  def test_soccer_player_has_height_in_feet
    assert_equal "5' 10\"", @data_object.height_ft
  end


end
