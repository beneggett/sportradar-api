require 'test_helper'

class Sportradar::Api::Football::StatPack::DefenseTest < Minitest::Test

  def setup
    @attrs = {"tackles"=>"32", "assists"=>"22", "combined"=>"54", "sacks"=>"3.0", "sack_yards"=>"44.0", "interceptions"=>"0", "passes_defended"=>"5", "forced_fumbles"=>"1", "fumble_recoveries"=>"1", "qb_hits"=>"5", "tloss"=>"3.0", "tloss_yards"=>"7.0", "safeties"=>"0", "sp_tackles"=>"4", "sp_assists"=>"1", "sp_forced_fumbles"=>"1", "sp_fumble_recoveries"=>"0", "sp_blocks"=>"0", "misc_tackles"=>"0", "misc_assists"=>"0", "misc_forced_fumbles"=>"0", "misc_fumble_recoveries"=>"0", "missed_tackles"=>"10", "player"=> [{"name"=>"Jeron Johnson", "jersey"=>"20", "reference"=>"00-0028441", "id"=>"d58339ad-6ec1-41cd-98d7-964ac47d7225", "position"=>"S", "tackles"=>"0", "assists"=>"0", "combined"=>"0", "sacks"=>"0.0", "sack_yards"=>"0.0", "interceptions"=>"0", "passes_defended"=>"0", "forced_fumbles"=>"0", "fumble_recoveries"=>"0", "qb_hits"=>"0", "tloss"=>"1.0", "tloss_yards"=>"0.0", "safeties"=>"0", "sp_tackles"=>"0", "sp_assists"=>"0", "sp_forced_fumbles"=>"0", "sp_fumble_recoveries"=>"0", "sp_blocks"=>"0", "misc_tackles"=>"0", "misc_assists"=>"0", "misc_forced_fumbles"=>"0", "misc_fumble_recoveries"=>"0", "missed_tackles"=>"0"}]}
  end

  def test_stat_pack_defense_initializes
    data_object = Sportradar::Api::Football::StatPack::Defense.new(@attrs)
    assert [:tackles, :sacks, :sack_yards].all? { |e| data_object.attributes.include?(e) }
  end


end
