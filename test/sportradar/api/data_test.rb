require 'test_helper'

class DummyData < Sportradar::Api::Data
  attr_accessor :test, :not_set

  def initialize(options = {})
    @test = options[:test]
    @not_set = options[:not_set]
  end
end

class Sportradar::Api::ContentTest < Minitest::Test

  def test_it_has_set_attributes
    a = DummyData.new(test: true)
    assert a.attributes.count, 1
    assert_includes a.attributes, :test
    refute_includes a.attributes, :not_set
  end

  def test_it_shows_all_attributes
    a = DummyData.new(test: true)
    assert a.all_attributes.count, 2
    assert_includes a.all_attributes, :not_set, :test
  end

end
