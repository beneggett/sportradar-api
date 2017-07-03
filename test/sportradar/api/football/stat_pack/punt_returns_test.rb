require 'test_helper'

class Sportradar::Api::Football::StatPack::PuntReturnsTest < Minitest::Test

  def setup
    @attrs =  {"totals"=>{"avg_yards"=>6.0, "yards"=>6, "longest"=>6, "touchdowns"=>0, "longest_touchdown"=>0, "faircatches"=>4, "number"=>1},
 "players"=>[{"name"=>"Trevor Davis", "jersey"=>"11", "reference"=>"00-0032423", "id"=>"bc175901-4a1f-4132-abb4-e49cc7d35e12", "position"=>"WR", "yards"=>6, "avg_yards"=>6.0, "touchdowns"=>0, "longest"=>6, "faircatches"=>4, "longest_touchdown"=>0, "number"=>1}]}
  end

  def test_stat_pack_punt_returns_initializes
    data_object = Sportradar::Api::Football::StatPack::PuntReturns.new(@attrs)
    assert [:longest].all? { |e| data_object.attributes.include?(e) }
  end


end
