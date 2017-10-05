require 'test_helper'

class Sportradar::Api::Soccer::BoxscoreTest < Minitest::Test

  def setup
    @attrs = {"boxscore"=> {"matches"=> {"match"=> [{"id"=>"3f7eb973-daab-49e5-b91a-6ab7cc1301a1", "status"=>"closed", "period"=>"P2", "scheduled"=>"2016-09-30T00:00:00Z", "clock"=>"", "scratched"=>"false"} ] } } }
  end

  def test_it_initializes_a_soccer_boxscore
    data_object = Sportradar::Api::Soccer::Boxscore.new(@attrs)
    assert [:matches].all? { |e| data_object.attributes.include?(e) }
  end

end
