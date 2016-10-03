require 'test_helper'

class Sportradar::Api::Images::TagTest < Minitest::Test

  def setup
    @attrs = {"type"=>"location", "value"=>"Superdome"}
  end

  def test_it_initializes_an_image_link
    data_object = Sportradar::Api::Images::Tag.new(@attrs)
    assert [:type, :value].all? { |e| data_object.attributes.include?(e) }
  end

end
