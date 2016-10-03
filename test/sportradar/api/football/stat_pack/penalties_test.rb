require 'test_helper'

class Sportradar::Api::Football::StatPack::PenaltiesTest < Minitest::Test

  def setup
    @attrs = {"penalties"=>"11", "yards"=>"88", "player"=> [{"name"=>"Keenan Robinson", "jersey"=>"52", "reference"=>"00-0029545", "id"=>"af1648a4-2df1-40ef-b9fe-081d6961a416", "position"=>"LB", "penalties"=>"1", "yards"=>"3"}, {"name"=>"Ty Nsekhe", "jersey"=>"79", "reference"=>"00-0029709", "id"=>"d723ebff-0e9d-42f8-93d2-fe0c02252de8", "position"=>"T", "penalties"=>"1", "yards"=>"10"}, {"name"=>"Derek Carrier", "jersey"=>"89", "reference"=>"00-0029119", "id"=>"d3fab07b-f02a-433d-9612-cb0a751f324d", "position"=>"TE", "penalties"=>"1", "yards"=>"10"}]}
  end

  def test_stat_pack_penalties_initializes
    data_object = Sportradar::Api::Football::StatPack::Penalties.new(@attrs)
    assert [:penalties, :yards].all? { |e| data_object.attributes.include?(e) }
  end


end
