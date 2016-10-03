require 'test_helper'

class Sportradar::Api::Football::StatPack::KickReturnsTest < Minitest::Test

  def setup
    @attrs = {"avg_yards"=>"36.0", "returns"=>"1", "yards"=>"36", "longest"=>"36", "touchdowns"=>"0", "longest_touchdown"=>"0", "faircatches"=>"0", "player"=> {"name"=>"Chris Thompson", "jersey"=>"25", "reference"=>"00-0030404", "id"=>"0366fd06-19a3-4b69-8448-6bfbfad1250b", "position"=>"RB", "returns"=>"1", "yards"=>"36", "avg_yards"=>"36.0", "touchdowns"=>"0", "longest"=>"36", "faircatches"=>"0", "longest_touchdown"=>"0"}}
  end

  def test_stat_pack_kick_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::KickReturns.new(@attrs)
    assert [:returns, :yards, :longest].all? { |e| data_object.attributes.include?(e) }
  end


end
