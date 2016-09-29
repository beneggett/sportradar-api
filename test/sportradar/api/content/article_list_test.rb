require 'test_helper'

class Sportradar::Api::Content::ArticleListTest < Minitest::Test

  def setup
    @attrs = {"provider"=>"tsx", "sport"=>"nfl", "start_time"=>"2016-09-29T00:00:00+00:00", "end_time"=>"2016-09-29T23:59:59+00:00", "item"=> [{"id"=>"c6051c7f-2ade-4cf6-8513-9096ecf20884", "type"=>"news"} ] }
  end

  def test_it_initializes_an_article_list
    data_object = Sportradar::Api::Content::ArticleList.new(@attrs)
    assert [:sport, :start_time].all? { |e| data_object.attributes.include?(e) }
  end

end
