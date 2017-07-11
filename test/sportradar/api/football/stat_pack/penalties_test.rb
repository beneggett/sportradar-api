require 'test_helper'

class Sportradar::Api::Football::StatPack::PenaltiesTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"penalties"=>9, "yards"=>56},
 "players"=>
  [{"name"=>"Aaron Rodgers", "jersey"=>"12", "reference"=>"00-0023459", "id"=>"0ce48193-e2fa-466e-a986-33f751add206", "position"=>"QB", "penalties"=>1, "yards"=>5},
   {"name"=>"T.J. Lang", "jersey"=>"70", "reference"=>"00-0027078", "id"=>"3ebbc479-fec5-4463-8eb1-b9b09b0d3bc2", "position"=>"G", "penalties"=>1, "yards"=>5}]
 }
  end

  def test_stat_pack_penalties_initializes
    data_object = Sportradar::Api::Football::StatPack::Penalties.new(@attrs)
    assert [:penalties, :yards].all? { |e| data_object.attributes.include?(e) }
  end


end
