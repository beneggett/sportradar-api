require 'test_helper'

class Sportradar::Api::Nfl::HierarchyTest < Minitest::Test

  def setup
    @attrs = {"xmlns"=>"http://feed.elasticstats.com/schema/nfl/premium/hierarchy-v2.0.xsd", "id"=>"3c6d318a-6164-4290-9bbc-bf9bb21cc4b8", "name"=>"National Football League", "alias"=>"NFL", "conference"=> [{"id"=>"1bdefe12-6cb2-4d6a-b208-b04602ae79c3", "name"=>"AFC", "alias"=>"AFC", "division"=> [{"id"=>"b95cd27d-d631-4fe1-bc05-0ae47fc0b14b", "name"=>"AFC East", "alias"=>"AFC_EAST", "team"=> [{"name"=>"Bills", "market"=>"Buffalo", "alias"=>"BUF", "id"=>"768c92aa-75ff-4a43-bcc0-f2798c2e1724", "venue"=> {"id"=>"e9e0828e-37fc-4238-a317-49037577dd55", "name"=>"New Era Field", "city"=>"Orchard Park", "state"=>"NY", "country"=>"USA", "zip"=>"14127", "address"=>"One Bills Drive", "capacity"=>"73079", "surface"=>"artificial", "roof_type"=>"outdoor"}}, {"name"=>"Dolphins", "market"=>"Miami", "alias"=>"MIA", "id"=>"4809ecb0-abd3-451d-9c4a-92a90b83ca06", "venue"=> {"id"=>"50a5c833-1570-4c38-abc7-7914cf87dbde", "name"=>"Hard Rock Stadium", "city"=>"Miami Gardens", "state"=>"FL", "country"=>"USA", "zip"=>"33056", "address"=>"2269 Northwest 199th Street", "capacity"=>"76100", "surface"=>"turf", "roof_type"=>"outdoor"}}, {"name"=>"Jets", "market"=>"New York", "alias"=>"NYJ", "id"=>"5fee86ae-74ab-4bdd-8416-42a9dd9964f3", "venue"=> {"id"=>"5d4c85c7-d84e-4e10-bd6a-8a15ebecca5c", "name"=>"MetLife Stadium", "city"=>"East Rutherford", "state"=>"NJ", "country"=>"USA", "zip"=>"07073", "address"=>"One MetLife Stadium Drive", "capacity"=>"82500", "surface"=>"artificial", "roof_type"=>"outdoor"}}, {"name"=>"Patriots", "market"=>"New England", "alias"=>"NE", "id"=>"97354895-8c77-4fd4-a860-32e62ea7382a", "venue"=> {"id"=>"e43310b1-cb82-4df9-8be5-e9b39637031b", "name"=>"Gillette Stadium", "city"=>"Foxborough", "state"=>"MA", "country"=>"USA", "zip"=>"02035", "address"=>"One Patriot Place", "capacity"=>"68756", "surface"=>"artificial", "roof_type"=>"outdoor"}}]}]}]}

  end

  def test_it_initializes_an_nfl_hierarchy
    data_object = Sportradar::Api::Nfl::Hierarchy.new(@attrs)
    assert [:name, :conferences, :divisions, :teams].all? { |e| data_object.attributes.include?(e) }
  end

end
