require 'test_helper'

class Sportradar::Api::Content::ReferenceTest < Minitest::Test

  def setup
    @attrs = {"sportradar_id"=>"de760528-1dc0-416a-a978-b510d20692ff", "sportsdata_id"=>"ARI", "type"=>"organization", "name"=>"Arizona Cardinals"}
  end

  def test_it_initializes_an_article
    data_object = Sportradar::Api::Content::Reference.new(@attrs)
    assert [:sportradar_id, :sportsdata_id, :type, :name].all? { |e| data_object.attributes.include?(e) }
  end

end
