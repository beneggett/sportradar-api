require 'test_helper'

class Sportradar::Api::Soccer::HierarchyTest < Minitest::Test

  def setup
    @attrs = {"category"=> [{"id"=>"c4ef0886-dfee-4725-81eb-1bb919be832a", "name"=>"International Clubs", "country_code"=>"XZ", "country"=>"International", "reference_id"=>"sr:category:393", "tournament_group"=> {"id"=>"dc3ea36c-1a29-41e3-b830-9dd2c685670a", "name"=>"CONCACAF CL", "season_start"=>"2016-08-01T22:00:00Z", "season_end"=>"2017-04-27T21:59:00Z", "season"=>"2016", "reference_id"=>"sr:tournamentgroup:498", "tournament"=> [{"id"=>"f1651216-f4f1-4e61-bd58-92a80df54df3", "name"=>"CONCACAF Champions League, Group 6", "season_id"=>"42881571-769d-4877-9f85-71868dc510d1", "season_start"=>"2016-08-01T22:00:00Z", "season_end"=>"2017-04-27T21:59:00Z", "season"=>"2016", "type"=>"group", "type_group_id"=>"6", "reference_id"=>"sr:tournament:21399"}] } }] }
  end

  def test_it_initializes_a_soccer_hierarchy
    data_object = Sportradar::Api::Soccer::Hierarchy.new(@attrs)
    assert [:categories].all? { |e| data_object.attributes.include?(e) }
  end

end
