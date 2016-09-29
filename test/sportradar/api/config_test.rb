require 'test_helper'

class Sportradar::Api::ConfigTest < Minitest::Test

  def test_it_sets_and_clears_configurations
    Sportradar::Api.configure  do |config|
      config.api_timeout = 3
      config.use_ssl = false
      config.format = :json
    end
    assert_equal Sportradar::Api.config.api_timeout, 3
    assert_equal Sportradar::Api.config.use_ssl, false
    assert_equal Sportradar::Api.config.format, :json

    Sportradar::Api.config.reset
    refute_equal Sportradar::Api.config.api_timeout, 3
    refute_equal Sportradar::Api.config.use_ssl, false
    refute_equal Sportradar::Api.config.format, :json

  end


end
