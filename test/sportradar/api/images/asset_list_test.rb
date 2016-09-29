require 'test_helper'

class Sportradar::Api::Images::AssetListTest < Minitest::Test

  def setup
    @attrs = {"type"=>"players headshots", "sport"=>"NFL", "asset"=> [{"id"=>"d038af5c-6dbb-4a92-927d-86b2335d5d99", "created"=>"2016-09-20T16:27:11+0000"} ] }
  end

  def test_it_initializes_an_image_asset_list
    data_object = Sportradar::Api::Images::AssetList.new(@attrs)
    assert [:sport, :type, :assets].all? { |e| data_object.attributes.include?(e) }
  end

end
