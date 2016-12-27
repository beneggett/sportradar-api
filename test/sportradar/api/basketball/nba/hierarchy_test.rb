require 'test_helper'

class Sportradar::Api::Basketball::Nba::HierarchyTest < Minitest::Test

  def setup
    @attrs = {
      "xmlns"=>"http://feed.elasticstats.com/schema/basketball/nba/hierarchy-v2.0.xsd",
      "id"=>"4353138d-4c22-4396-95d8-5f587d2df25c",
      "name"=>"NBA",
      "alias"=>"NBA",
      "conference"=>
      [{"id"=>"3960cfac-7361-4b30-bc25-8d393de6f62f",
        "name"=>"EASTERN CONFERENCE",
        "alias"=>"EASTERN",
        "division"=>
         [{"id"=>"54dc7348-c1d2-40d8-88b3-c4c0138e085d",
           "name"=>"Southeast",
           "alias"=>"SOUTHEAST",
           "team"=>
            [{"id"=>"583ec8d4-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Wizards",
              "market"=>"Washington",
              "alias"=>"WAS",
              "venue"=>{"id"=>"f62d5b49-d646-56e9-ba60-a875a00830f8", "name"=>"Verizon Center", "capacity"=>"20356", "address"=>"601 F St. N.W.", "city"=>"Washington", "state"=>"DC", "zip"=>"20004", "country"=>"USA"}},
             {"id"=>"583ec97e-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Hornets",
              "market"=>"Charlotte",
              "alias"=>"CHA",
              "venue"=>{"id"=>"a380f011-6e5d-5430-9f37-209e1e8a9b6f", "name"=>"Spectrum Center", "capacity"=>"19077", "address"=>"330 E. Trade St.", "city"=>"Charlotte", "state"=>"NC", "zip"=>"28202", "country"=>"USA"}},
             {"id"=>"583ecb8f-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Hawks",
              "market"=>"Atlanta",
              "alias"=>"ATL",
              "venue"=>{"id"=>"fd21f639-8a47-51ac-a5dd-590629d445cf", "name"=>"Philips Arena", "capacity"=>"18118", "address"=>"One Philips Drive", "city"=>"Atlanta", "state"=>"GA", "zip"=>"30303", "country"=>"USA"}},
             {"id"=>"583ecea6-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Heat",
              "market"=>"Miami",
              "alias"=>"MIA",
              "venue"=>{"id"=>"b67d5f09-28b2-5bc6-9097-af312007d2f4", "name"=>"American Airlines Arena", "capacity"=>"19600", "address"=>"601 Biscayne Blvd.", "city"=>"Miami", "state"=>"FL", "zip"=>"33132", "country"=>"USA"}},
             {"id"=>"583ed157-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Magic",
              "market"=>"Orlando",
              "alias"=>"ORL",
              "venue"=>{"id"=>"aecd8da6-0404-599c-a792-4b33fb084a2a", "name"=>"Amway Center", "capacity"=>"18846", "address"=>"400 W. Church St.", "city"=>"Orlando", "state"=>"FL", "zip"=>"32801", "country"=>"USA"}}]}]}]}

    @data_object = Sportradar::Api::Basketball::Nba::Hierarchy.new(@attrs)
  end

  def test_it_initializes_an_nfl_hierarchy
    assert [:name, :alias].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_it_has_conferences
    refute_empty @data_object.conferences
  end

  def test_it_has_divisions
    refute_empty @data_object.divisions
  end

  def test_it_has_teams
    refute_empty @data_object.teams
  end

end
