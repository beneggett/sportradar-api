require 'test_helper'

class Sportradar::Api::Football::StatPack::FieldGoalsTest < Minitest::Test

  def setup
    @attrs = {"totals"=>{"attempts"=>3, "made"=>2, "blocked"=>1, "yards"=>72, "avg_yards"=>36.0, "longest"=>40, "net_attempts"=>2},
 "players"=>[{"name"=>"Mason Crosby", "jersey"=>"02", "reference"=>"00-0025580", "id"=>"e0856548-6fd5-4f83-9aa0-91f1bf4cbbd8", "position"=>"K", "attempts"=>3, "made"=>2, "blocked"=>1, "yards"=>72, "avg_yards"=>36.0, "longest"=>40}]}
  end

  def test_stat_pack_field_goals_initializes
    data_object = Sportradar::Api::Football::StatPack::FieldGoals.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
