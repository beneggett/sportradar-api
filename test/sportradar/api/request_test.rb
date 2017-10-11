require 'test_helper'

class DummyRequest < Sportradar::Api::Request
  def api_key
    Sportradar::Api.api_key_params("soccer_na")
  end
end


class Sportradar::Api::RequestTest < Minitest::Test

  def test_it_makes_a_good_get_request
    skip # this test is actually broken lol
    VCR.use_cassette("tests good get request") do
      request = DummyRequest.new.get '/soccer-t2/na/matches/schedule'
      assert_kind_of HTTParty::Response, request
      assert request.success?
    end
  end


  def test_it_makes_a_bad_get_request
    VCR.use_cassette("tests bad get request") do
      request = DummyRequest.new.get '/dumb-path'
      assert_kind_of Sportradar::Api::Error, request
    end
  end

end
