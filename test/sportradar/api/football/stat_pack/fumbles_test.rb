require 'test_helper'

class Sportradar::Api::Football::StatPack::FumblesTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"fumbles"=>2, "lost_fumbles"=>1, "own_rec"=>1, "own_rec_yards"=>0, "opp_rec"=>0, "opp_rec_yards"=>0, "out_of_bounds"=>0, "forced_fumbles"=>0, "own_rec_tds"=>0, "opp_rec_tds"=>0, "ez_rec_tds"=>0},
 "players"=>
  [{"name"=>"Trevor Davis",
    "jersey"=>"11",
    "reference"=>"00-0032423",
    "id"=>"bc175901-4a1f-4132-abb4-e49cc7d35e12",
    "position"=>"WR",
    "fumbles"=>1,
    "lost_fumbles"=>0,
    "own_rec"=>0,
    "own_rec_yards"=>0,
    "opp_rec"=>0,
    "opp_rec_yards"=>0,
    "out_of_bounds"=>0,
    "forced_fumbles"=>0,
    "own_rec_tds"=>0,
    "opp_rec_tds"=>0,
    "ez_rec_tds"=>0}]
}
  end

  def test_stat_pack_fumbles_initializes
    data_object = Sportradar::Api::Football::StatPack::Fumbles.new(@attrs)
    assert [:fumbles, :lost_fumbles].all? { |e| data_object.attributes.include?(e) }
  end


end
