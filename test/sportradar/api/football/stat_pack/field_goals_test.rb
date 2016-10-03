require 'test_helper'

class Sportradar::Api::Football::StatPack::FieldGoalsTest < Minitest::Test

  def setup
    @attrs = {"attempts"=>"2", "made"=>"1", "blocked"=>"0", "yards"=>"45", "avg_yards"=>"22.5", "longest"=>"45", "net_attempts"=>"2", "player"=> {"name"=>"Kai Forbath", "jersey"=>"02", "reference"=>"00-0028787", "id"=>"5514afb6-bd43-49a8-9bf7-b8baaaecdabe", "position"=>"K", "attempts"=>"2", "made"=>"1", "blocked"=>"0", "yards"=>"45", "avg_yards"=>"22.5", "longest"=>"45"}}
  end

  def test_stat_pack_field_goals_initializes
    data_object = Sportradar::Api::Football::StatPack::FieldGoals.new(@attrs)
    assert [:longest, :attempts].all? { |e| data_object.attributes.include?(e) }
  end


end
