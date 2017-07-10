require 'test_helper'

class Sportradar::Api::Football::Nfl::PlayerTest < Minitest::Test

  def setup
    data = { "id"=>"409d4cac-ee90-4470-9710-ebe671678339" }
    @team = Sportradar::Api::Football::Nfl::Player.new(data)
  end

end
