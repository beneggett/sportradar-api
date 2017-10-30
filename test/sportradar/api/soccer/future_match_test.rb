require 'test_helper'

class Sportradar::Api::Soccer::FutureMatchTest < Minitest::Test

  def setup
    data = {"id"=>"sr:match:12090446"}
    @match = Sportradar::Api::Soccer::Match.new(data, league_group: 'eu')
  end

  def test_it_initializes_a_match
    assert_instance_of Sportradar::Api::Soccer::Match, @match
    assert_equal 'eu', @match.league_group
    assert_equal "sr:match:12090446", @match.id
  end

  def test_it_gets_summary
    VCR.use_cassette("soccer/#{@match.api.content_format}/match/future_summary") do
      @match.get_summary
    end
    assert_equal "not_started", @match.match_status
    assert_equal "not_started", @match.status
    assert_instance_of Sportradar::Api::Soccer::Venue, @match.venue
    assert_equal Time.utc(2018, 05, 20, 18, 45, 00), @match.scheduled
  end

  def test_it_gets_timeline
    # get timeline
    # assert @match.coverage_info.coverage['key_events']
  end


end
