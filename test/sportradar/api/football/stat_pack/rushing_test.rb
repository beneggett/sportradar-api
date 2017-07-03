require 'test_helper'

class Sportradar::Api::Football::StatPack::RushingTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"avg_yards"=>4.5, "attempts"=>23, "touchdowns"=>0, "tlost"=>0, "tlost_yards"=>0, "yards"=>103, "longest"=>30, "longest_touchdown"=>0, "redzone_attempts"=>3},
       "players"=>
        [{"name"=>"Ty Montgomery",
          "jersey"=>"88",
          "reference"=>"00-0032200",
          "id"=>"0c39e276-7a5b-448f-a696-532506f1035a",
          "position"=>"WR",
          "avg_yards"=>6.7,
          "attempts"=>9,
          "touchdowns"=>0,
          "yards"=>60,
          "longest"=>30,
          "longest_touchdown"=>0,
          "redzone_attempts"=>1,
          "tlost"=>0,
          "tlost_yards"=>0}]
      }
  end

  def test_stat_pack_rushing_initializes
    data_object = Sportradar::Api::Football::StatPack::Rushing.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
