require 'test_helper'

class Sportradar::Api::Soccer::GroupTest < Minitest::Test

  def setup
    @group = Sportradar::Api::Soccer::Group.europe
  end

  def test_it_initializes_a_soccer_group
    assert_instance_of Sportradar::Api::Soccer::Group, @group
    assert_equal 'eu', @group.league_group
  end

  def test_it_has_tournaments
    VCR.use_cassette("soccer/#{@group.api.content_format}/group/tournaments_list") do
      @group.get_tournaments
      assert_equal 16, @group.tournaments.size
      assert_instance_of Sportradar::Api::Soccer::Tournament, @group.tournaments.first
    end
  end

end
