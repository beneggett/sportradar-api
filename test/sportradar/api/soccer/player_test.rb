require 'test_helper'

class Sportradar::Api::Soccer::PlayerTest < Minitest::Test

  def setup
    data = {"id"=>"sr:player:13249"}
    @player = Sportradar::Api::Soccer::Player.new(data, league_group: 'eu')
  end

  def test_it_initializes_a_player
    assert_instance_of Sportradar::Api::Soccer::Player, @player
    assert_equal 'eu', @player.league_group
  end

  def test_it_has_profile
    VCR.use_cassette("soccer/#{@player.api.content_format}/player/profile") do
      res = @player.get_profile
      assert_equal "Bravo, Claudio", @player.display_name
      assert_equal "goalkeeper", @player.type
      assert_equal @player.type, @player.position
    end
  end
  def test_it_queues_profile
    # this should get reworked but here's the basic premise
    hash = @player.queue_profile
    assert_instance_of Hash, hash
    assert_equal "https://api.sportradar.us/soccer-xt3/eu/en/players/sr:player:13249/profile.json", hash[:url]
    assert_equal({"Content-Type"=>"application/json", "Accept"=>"application/json"}, hash[:headers])
    assert_includes hash[:params], :api_key
    assert_instance_of Method, hash[:callback]
    assert_equal Sportradar::Api::Soccer::Player, hash[:callback].owner
  end

end
