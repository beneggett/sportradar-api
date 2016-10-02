require 'test_helper'

class Sportradar::Api::Nfl::ScoringTest < Minitest::Test

  def setup
    @attrs = {"quarter"=> [{"id"=>"fd31368b-a159-4f56-a022-afc691e34755", "number"=>"1", "sequence"=>"1", "home_points"=>"3", "away_points"=>"0"}, {"id"=>"17ee8c4c-3e1c-4dbb-83eb-f54fabe2a117", "number"=>"2", "sequence"=>"2", "home_points"=>"7", "away_points"=>"7"}, {"id"=>"da1c72aa-a5eb-44db-a23f-f9e2284d7968", "number"=>"3", "sequence"=>"3", "home_points"=>"0", "away_points"=>"0"}, {"id"=>"99063002-e5ee-4239-b686-f5aaa192e5d8", "number"=>"4", "sequence"=>"4", "home_points"=>"0", "away_points"=>"10"}]}
    @data_object = Sportradar::Api::Nfl::Scoring.new(@attrs)
  end

  def test_nfl_scoring_initializes
    assert [:quarters].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_scoring_has_final
    assert_equal "#{@data_object.home}-#{@data_object.away}", @data_object.final
  end

  def test_nfl_scoring_has_home
    assert_equal 10, @data_object.home
  end

  def test_nfl_scoring_has_away
    assert_equal 17, @data_object.away
  end

end
