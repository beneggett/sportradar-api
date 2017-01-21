require 'test_helper'

class Sportradar::Api::Basketball::Nba::TeamTest < Minitest::Test

  def setup
    @attrs = {"id"=>"583ec8d4-fb46-11e1-82cb-f4ce4684ea4c",
              "name"=>"Wizards",
              "market"=>"Washington",
              "alias"=>"WAS",
              "venue"=>{"id"=>"f62d5b49-d646-56e9-ba60-a875a00830f8", "name"=>"Verizon Center", "capacity"=>"20356", "address"=>"601 F St. N.W.", "city"=>"Washington", "state"=>"DC", "zip"=>"20004", "country"=>"USA"}}

    @data_object = Sportradar::Api::Basketball::Nba::Team.new(@attrs)
  end

  def test_nba_team_initializes
    assert [:id, :name, :alias, :market, :venue].all? { |e| @data_object.send(e) }
  end

  def test_nba_team_has_full_name
    assert_equal [@data_object.market, @data_object.name].join(' '), @data_object.full_name
  end

end
