require 'test_helper'

class Sportradar::Api::Football::StatPack::DefenseTest < Minitest::Test

  def setup
    @attrs = {"totals"=>
  {"tackles"=>25,
   "assists"=>13,
   "combined"=>38,
   "sacks"=>1.0,
   "sack_yards"=>10.0,
   "interceptions"=>2,
   "passes_defended"=>9,
   "forced_fumbles"=>0,
   "fumble_recoveries"=>0,
   "qb_hits"=>5,
   "tloss"=>3.0,
   "tloss_yards"=>12.0,
   "safeties"=>0,
   "sp_tackles"=>2,
   "sp_assists"=>0,
   "sp_forced_fumbles"=>0,
   "sp_fumble_recoveries"=>1,
   "sp_blocks"=>0,
   "misc_tackles"=>0,
   "misc_assists"=>0,
   "misc_forced_fumbles"=>0,
   "misc_fumble_recoveries"=>0},
 "players"=>
  [{"name"=>"Joe Thomas",
    "jersey"=>"48",
    "reference"=>"00-0030761",
    "id"=>"fa059382-e52c-40c8-93fd-bd69decdc1c8",
    "position"=>"LB",
    "tackles"=>0,
    "assists"=>1,
    "combined"=>1,
    "sacks"=>0.0,
    "sack_yards"=>0.0,
    "interceptions"=>0,
    "passes_defended"=>0,
    "forced_fumbles"=>0,
    "fumble_recoveries"=>0,
    "qb_hits"=>0,
    "tloss"=>0.0,
    "tloss_yards"=>0.0,
    "safeties"=>0,
    "sp_tackles"=>0,
    "sp_assists"=>0,
    "sp_forced_fumbles"=>0,
    "sp_fumble_recoveries"=>0,
    "sp_blocks"=>0,
    "misc_tackles"=>0,
    "misc_assists"=>0,
    "misc_forced_fumbles"=>0,
    "misc_fumble_recoveries"=>0}]
  }
  end

  def test_stat_pack_defense_initializes
    data_object = Sportradar::Api::Football::StatPack::Defense.new(@attrs)
    assert [:tackles, :sacks, :sack_yards].all? { |e| data_object.attributes.include?(e) }
  end


end
