require 'test_helper'


class Sportradar::Api::ErrorTest < Minitest::Test

  def test_it_is_an_error
    error = Sportradar::Api::Error.new(500, 'Internal Error', {message: 'Bye Bye'} )
    refute error.success?
  end

end
