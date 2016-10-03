require 'test_helper'

class Sportradar::Api::Football::StatPack::PuntsTest < Minitest::Test

  def setup
    @attrs = {"attempts"=>"3", "yards"=>"124", "net_yards"=>"30", "blocked"=>"0", "touchbacks"=>"1", "inside_20"=>"1", "return_yards"=>"74", "avg_net_yards"=>"10.0", "avg_yards"=>"41.3", "longest"=>"54", "player"=> {"name"=>"Tress Way", "jersey"=>"05", "reference"=>"00-0030140", "id"=>"55e1ecbd-96c5-456e-833b-9cd3f046f3fc", "position"=>"P", "attempts"=>"3", "yards"=>"124", "avg_yards"=>"41.3", "blocked"=>"0", "longest"=>"54", "touchbacks"=>"1", "inside_20"=>"1", "avg_net_yards"=>"10.0", "return_yards"=>"74", "net_yards"=>"30"}}
  end

  def test_stat_pack_punts_initializes
    data_object = Sportradar::Api::Football::StatPack::Punts.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
