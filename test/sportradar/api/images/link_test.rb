require 'test_helper'

class Sportradar::Api::Images::LinkTest < Minitest::Test

  def setup
    @attrs = {"width"=>"2786", "height"=>"2786", "href"=>"/players/headshots/d038af5c-6dbb-4a92-927d-86b2335d5d99/original.jpg"}
  end

  def test_it_initializes_an_image_link
    data_object = Sportradar::Api::Images::Link.new(@attrs)
    assert [:width, :height, :href].all? { |e| data_object.attributes.include?(e) }
  end

end
