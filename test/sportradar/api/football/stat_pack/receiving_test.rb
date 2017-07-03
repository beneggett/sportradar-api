require 'test_helper'

class Sportradar::Api::Football::StatPack::ReceivingTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"targets"=>56, "receptions"=>39, "avg_yards"=>8.359, "yards"=>326, "touchdowns"=>3, "yards_after_catch"=>157, "longest"=>25, "longest_touchdown"=>5, "redzone_targets"=>5, "air_yards"=>169},
       "players"=>
        [{"name"=>"Randall Cobb",
          "jersey"=>"18",
          "reference"=>"00-0028002",
          "id"=>"3283f152-d373-43b3-b88f-f6f261c48e81",
          "position"=>"WR",
          "receptions"=>11,
          "targets"=>15,
          "yards"=>95,
          "avg_yards"=>8.6,
          "longest"=>25,
          "touchdowns"=>1,
          "longest_touchdown"=>2,
          "yards_after_catch"=>59,
          "redzone_targets"=>1,
          "air_yards"=>36}]
      }
  end

  def test_stat_pack_receiving_initializes
    data_object = Sportradar::Api::Football::StatPack::Receiving.new(@attrs)
    assert [:longest].all? { |e| data_object.attributes.include?(e) }
  end


end
