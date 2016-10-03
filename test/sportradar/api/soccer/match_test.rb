require 'test_helper'

class Sportradar::Api::Soccer::MatchTest < Minitest::Test

  def setup
    @attrs = {"id"=>"3f7eb973-daab-49e5-b91a-6ab7cc1301a1", "status"=>"closed", "period"=>"P2", "scheduled"=>"2016-09-30T00:00:00Z", "clock"=>"", "scratched"=>"false"}
    @data_object = Sportradar::Api::Soccer::Match.new(@attrs)
  end

  def test_it_initializes_a_soccer_match

    assert [:status, :period].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_match_has_a_period_name
    assert_equal "Period two", @data_object.period_name
  end

  def test_match_has_a_status_description
    assert_equal "The match is over", @data_object.status_description
  end

end
