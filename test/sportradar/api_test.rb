require 'test_helper'

class Sportradar::ApiTest < Minitest::Test

  def test_that_it_has_a_version_number
    refute_nil ::Sportradar::Api::VERSION
  end

  def test_it_retrieves_an_api_key
    assert_equal Sportradar::Api.api_key(:soccer_na), ENV["SPORTRADAR_SOCCER_NA"]
  end

  def test_it_gets_api_key_params
    assert_equal Sportradar::Api.api_key_params(:soccer_na), { api_key: ENV["SPORTRADAR_SOCCER_NA"] }
  end

  def test_it_finds_the_appropriate_api_version
    assert_equal Sportradar::Api.version(:nascar), 3
  end
end
