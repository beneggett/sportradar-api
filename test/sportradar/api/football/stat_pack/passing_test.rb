require 'test_helper'

class Sportradar::Api::Football::StatPack::PassingTest < Minitest::Test

  def setup
    @attrs = {"attempts"=>"31", "completions"=>"21", "cmp_pct"=>"67.7", "interceptions"=>"2", "sack_yards"=>"8", "rating"=>"68.8", "touchdowns"=>"1", "avg_yards"=>"5.9", "sacks"=>"1", "longest"=>"25", "longest_touchdown"=>"4", "air_yards"=>"132", "redzone_attempts"=>"3", "net_yards"=>"188", "yards"=>"196", "player"=> {"name"=>"Kirk Cousins", "jersey"=>"08", "reference"=>"00-0029604", "id"=>"bbd0942c-6f77-4f83-a6d0-66ec6548019e", "position"=>"QB", "attempts"=>"31", "completions"=>"21", "cmp_pct"=>"67.7", "yards"=>"196", "avg_yards"=>"6.3", "sacks"=>"1", "sack_yards"=>"8", "touchdowns"=>"1", "longest"=>"25", "interceptions"=>"2", "rating"=>"68.8", "longest_touchdown"=>"4", "air_yards"=>"132", "redzone_attempts"=>"3"}}
  end

  def test_stat_pack_passing_initializes
    data_object = Sportradar::Api::Football::StatPack::Passing.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
