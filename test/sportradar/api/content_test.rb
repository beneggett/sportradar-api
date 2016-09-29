require 'test_helper'

class Sportradar::Api::ContentTest < Minitest::Test

  def test_it_accepts_a_valid_sport
    good = Sportradar::Api::Content.new('nfl')
    assert_kind_of Sportradar::Api::Content, good
    assert_raises Sportradar::Api::Error::InvalidSport do
      Sportradar::Api::Content.new('make-believe')
    end
  end

  def test_it_accepts_a_valid_access_level
    good = Sportradar::Api::Content.new('nfl', 'p')
    assert_kind_of Sportradar::Api::Content, good
    assert_raises Sportradar::Api::Error::InvalidAccessLevel do
      Sportradar::Api::Content.new('nfl', 'dumb')
    end
  end

  def test_it_makes_a_good_news_request
    VCR.use_cassette("tests good news request") do
      request = Sportradar::Api::Content.new('nfl', 't').news(good_date)
      refute_kind_of Sportradar::Api::Content::ArticleList, request
      assert_kind_of Sportradar::Api::Error, request # The commented above will fail until I have a good api key
    end
  end

  def test_it_doesnt_make_a_news_request_with_bad_content_type
    assert_raises Sportradar::Api::Error::InvalidType do
      Sportradar::Api::Content.new('nfl', 't').news(Date.today, content_type: 'bad')
    end
  end

  def test_it_makes_a_good_analysis_request
    VCR.use_cassette("tests good analysis request") do
      request = Sportradar::Api::Content.new('nfl', 't').analysis(good_date)
      refute_kind_of Sportradar::Api::Content::ArticleList, request
      assert_kind_of Sportradar::Api::Error, request # The commented above will fail until I have a good api key
    end
  end

  def test_it_doesnt_make_a_analysis_request_with_bad_content_type
    assert_raises Sportradar::Api::Error::InvalidType do
      Sportradar::Api::Content.new('nfl', 't').analysis(Date.today, content_type: 'bad')
    end
  end

end
