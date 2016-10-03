require 'test_helper'

class Sportradar::Api::Images::AssetTest < Minitest::Test

  def setup
    @attrs = {"id"=>"d038af5c-6dbb-4a92-927d-86b2335d5d99", "created"=>"2016-09-20T16:27:11+0000", "updated"=>"2016-09-20T16:27:15+0000", "player_id"=>"648a6a76-32c3-45fa-b158-f77de2a9a95f", "title"=>"Trevone Boykin", "description"=>"NFL: Preseason-Seattle Seahawks at Oakland Raiders", "copyright"=>"USA Today Sports Images", "links"=> {"link"=> [{"width"=>"2786", "height"=>"2786", "href"=>"/players/headshots/d038af5c-6dbb-4a92-927d-86b2335d5d99/original.jpg"}, {"width"=>"195", "height"=>"270", "href"=>"/players/headshots/d038af5c-6dbb-4a92-927d-86b2335d5d99/195x270.jpg"}]}}
  end

  def test_it_initializes_an_image_asset
    data_object = Sportradar::Api::Images::Asset.new(@attrs)
    assert [:player_id, :title, :links].all? { |e| data_object.attributes.include?(e) }
  end

end
