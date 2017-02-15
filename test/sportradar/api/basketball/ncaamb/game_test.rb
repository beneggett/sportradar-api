require 'test_helper'

class Sportradar::Api::Basketball::Ncaamb::GameTest < Minitest::Test

  def setup
    @response = {"id"=>"29111b80-992d-4e32-a88d-220fb4bd3121",
                 "status"=>"closed",
                 "coverage"=>"full",
                 "home_team"=>"ec0d6b67-4b16-4b50-92b2-1a651dae6b0f",
                 "away_team"=>"9b166a3f-e64b-4825-bb6b-92c6f0418263",
                 "scheduled"=>"2017-01-21T21:00:00+00:00",
                 "conference_game"=>"true",
                 "home_points"=>"85",
                 "away_points"=>"96",
                 "venue"=>{"id"=>"e7547c99-c087-4245-b039-19dc1f8df1b0", "name"=>"Pauley Pavilion", "capacity"=>"13800", "address"=>"301 Westwood Plaza", "city"=>"Los Angeles", "state"=>"CA", "zip"=>"90095", "country"=>"USA"},
                 "home"=>{"name"=>"UCLA Bruins", "alias"=>"UCLA", "id"=>"ec0d6b67-4b16-4b50-92b2-1a651dae6b0f", "__content__"=>"\n        "},
                 "away"=>{"name"=>"Arizona Wildcats", "alias"=>"ARIZ", "id"=>"9b166a3f-e64b-4825-bb6b-92c6f0418263", "__content__"=>"\n        "},
                 "broadcast"=>{"network"=>"CBS"}}

    @game = Sportradar::Api::Basketball::Ncaamb::Game.new(@response)

  end

  def test_ncaamb_game_initializes
    assert [:id, :scheduled, :venue, :broadcast, :coverage].all? { |e| @game.send(e) }
    assert_instance_of Sportradar::Api::Basketball::Venue, @game.venue
    assert_instance_of Sportradar::Api::Basketball::Broadcast, @game.broadcast
  end

  def test_ncaamb_game_has_score
    assert_equal ({ @game.home_id => 85, @game.away_id => 96 }), @game.score
  end
  def test_ncaamb_game_points
    assert_equal 96, @game.points(@game.away_id)
    assert_equal 96, @game.points(:away)
    assert_equal 85, @game.points(@game.home_id)
    assert_equal 85, @game.points(:home)
  end

  def test_ncaamb_game_has_scoring_placeholder
    assert_equal ({}), @game.scoring
  end

  def test_ncaamb_game_status_helpers
    assert @game.finished?
    assert @game.closed?
    refute @game.started?
    refute @game.future?
    @game.status = 'scheduled'
    assert @game.future?
  end

end
