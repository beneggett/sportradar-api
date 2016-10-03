require 'test_helper'

class Sportradar::Api::Football::StatPack::FumblesTest < Minitest::Test

  def setup
    @attrs = {"fumbles"=>"1", "lost_fumbles"=>"0", "own_rec"=>"0", "own_rec_yards"=>"-3", "opp_rec"=>"1", "opp_rec_yards"=>"0", "out_of_bounds"=>"1", "forced_fumbles"=>"2", "own_rec_tds"=>"0", "opp_rec_tds"=>"0", "ez_rec_tds"=>"0", "player"=> [{"name"=>"Preston Smith", "jersey"=>"94", "reference"=>"00-0031935", "id"=>"ede260be-5ae6-4a06-887b-e4a130932705", "position"=>"LB", "fumbles"=>"0", "lost_fumbles"=>"0", "own_rec"=>"0", "own_rec_yards"=>"0", "opp_rec"=>"1", "opp_rec_yards"=>"0", "out_of_bounds"=>"0", "forced_fumbles"=>"2", "own_rec_tds"=>"0", "opp_rec_tds"=>"0", "ez_rec_tds"=>"0"}, {"name"=>"Kirk Cousins", "jersey"=>"08", "reference"=>"00-0029604", "id"=>"bbd0942c-6f77-4f83-a6d0-66ec6548019e", "position"=>"QB", "fumbles"=>"1", "lost_fumbles"=>"0", "own_rec"=>"0", "own_rec_yards"=>"-3", "opp_rec"=>"0", "opp_rec_yards"=>"0", "out_of_bounds"=>"1", "forced_fumbles"=>"0", "own_rec_tds"=>"0", "opp_rec_tds"=>"0", "ez_rec_tds"=>"0"}]}
  end

  def test_stat_pack_fumbles_initializes
    data_object = Sportradar::Api::Football::StatPack::Fumbles.new(@attrs)
    assert [:fumbles, :lost_fumbles].all? { |e| data_object.attributes.include?(e) }
  end


end
