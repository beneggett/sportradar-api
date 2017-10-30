require 'test_helper'

class Sportradar::Api::Soccer::SummaryTest < Minitest::Test

  def setup
    @attrs = {"summary"=> {"matches"=> {"match"=> {"id"=>"357607e9-87cd-4848-b53e-0485d9c1a3bc", "status"=>"closed", "period"=>"P2", "scheduled"=>"2016-07-13T23:00:00Z", "clock"=>"", "scratched"=>"false", "season_id"=>"34913769-58a6-487d-aa7a-1883c8f87909", "coverage"=> {"lineups"=>"2", "tactical_lineups"=>"true", "corner_facts"=>"true", "extended_facts"=>"true"} } } } }
  end

  def test_it_initializes_a_soccer_summary
    data_object = Sportradar::Api::Soccer::Summary.new(@attrs)
    assert [:matches].all? { |e| data_object.attributes.include?(e) }
  end

end
