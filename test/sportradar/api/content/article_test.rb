require 'test_helper'

class Sportradar::Api::Content::ArticleTest < Minitest::Test

  def setup
    @attrs = {"id"=>"c6051c7f-2ade-4cf6-8513-9096ecf20884", "type"=>"news", "created"=>"2016-09-29T00:00:45+00:00", "updated"=>"2016-09-29T04:22:22+00:00", "injury"=>"false", "transaction"=>"false", "title"=>"Numerous roster changes for Cardinals", "byline"=>"The Sports Xchange", "dateline"=>nil, "credit"=>"The Sports Xchange", "content"=> {"long"=> "Arizona Cardinals general manager Steve Keim apparently wasn't kidding on Monday when he said several changes could be coming regarding his 1-2 football team. "}, "refs"=> {"ref"=> [{"sportradar_id"=>"de760528-1dc0-416a-a978-b510d20692ff", "sportsdata_id"=>"ARI", "type"=>"organization", "name"=>"Arizona Cardinals"} ]}, "provider"=>{"name"=>"tsx", "provider_content_id"=>"001531862", "original_publish"=>"2016-09-28T23:58:36+00:00"}}
  end

  def test_it_initializes_an_article
    data_object = Sportradar::Api::Content::Article.new(@attrs)
    assert [:title, :created, :type, :provider].all? { |e| data_object.attributes.include?(e) }
  end

  def test_it_is_a_transaction_type
    article = Sportradar::Api::Content::Article.new(@attrs.merge("transaction" => "true"))
    assert article.transaction?
  end

  def test_it_is_an_injury_type
    article = Sportradar::Api::Content::Article.new(@attrs.merge("injury" => "true"))
    assert article.injury?
  end

  def test_references_wont_break_if_null
    article = Sportradar::Api::Content::Article.new(@attrs.merge("refs" => nil))
    assert_equal article.references, []
    article = Sportradar::Api::Content::Article.new(@attrs.merge("refs" => {"ref" => nil}))
    assert_equal article.references, []
  end


end
