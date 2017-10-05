require 'test_helper'

class Sportradar::Api::Soccer::TeamTest < Minitest::Test

  def setup
    @attrs = {"id"=>"b78b9f61-0697-4347-a1b6-b7685a130eb1", "name"=>"Salt Lake", "full_name"=>"Real Salt Lake", "alias"=>"SAL", "country_code"=>"USA", "country"=>"United States", "type"=>"team", "reference_id"=>"sr:team:5133", "manager"=> {"id"=>"c0456c5f-51a0-4d12-996f-e3b2a1c7945c", "first_name"=>"Jeff", "last_name"=>"Cassar", "country_code"=>"USA", "country"=>"United States", "birthdate"=>"1974-02-02", "reference_id"=>"sr:manager:539898"}, "roster"=> {"player"=> [{"id"=>"640f8388-9feb-4142-933f-204aecb7ae9f", "first_name"=>"Justen", "last_name"=>"Glad"}] } }
  end

  def test_it_initializes_a_soccer_team
    data_object = Sportradar::Api::Soccer::Team.new(@attrs)
    assert [:name, :full_name, :alias, :country, :country_code, :manager, :players].all? { |e| data_object.attributes.include?(e) }
  end

  def test_it_parses_a_scoring_hash
    data_object = Sportradar::Api::Soccer::Team.new(@attrs.merge("scoring"=>{"half"=>{"points"=>"0", "number"=>"1"}} ) )
    assert_equal data_object.first_half_score, "0"

  end


end
