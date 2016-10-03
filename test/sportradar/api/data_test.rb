require 'test_helper'

class DummyData < Sportradar::Api::Data
  attr_accessor :test, :not_set, :hash_array, :parsed_hash

  def initialize(options = {})
    @test = options[:test]
    @not_set = options[:not_set]
    @hash_array = parse_into_array(selector: options[:hash_array], klass: OpenStruct) if options[:hash_array]
    @parsed_hash = parse_out_hashes options[:parsed_hash]
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
    assert a.all_attributes.count, 3
    assert_includes a.all_attributes, :not_set, :test
  end

  def test_it_converts_a_hash_or_array
    data_hash = DummyData.new(test: true, hash_array: {"cool" => "test"})
    assert_kind_of Array, data_hash.hash_array
    data_array = DummyData.new(test: true, hash_array: [{"cool" => "test"}])
    assert_kind_of Array, data_array.hash_array
  end

  def test_it_parses_an_array_of_hashes_into_a_hash
    data_hash = DummyData.new(test: true, parsed_hash: {"cool" => "test"})
    assert_kind_of Hash, data_hash.parsed_hash
    data_array = DummyData.new(test: true, parsed_hash: [{"cool" => "test"}])
    assert_kind_of Hash, data_array.parsed_hash
  end

end
