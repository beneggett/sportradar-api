require 'test_helper'

class Sportradar::ApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sportradar::Api::VERSION
  end

end
