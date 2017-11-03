require 'test_helper'

class Sportradar::Api::Soccer::LiveMatchTest < Minitest::Test

  def setup
    data = {"id"=>"sr:match:11913998", "league_group" => 'eu'}
    @match = Sportradar::Api::Soccer::Match.new(data)
  end

  def test_it_gets_timeline
    VCR.use_cassette("soccer/#{@match.api.content_format}/match/live_timeline") do
      @match.get_timeline
    end
    assert_equal "live", @match.status
    assert_equal "2nd_half", @match.match_status
    assert_equal 1, @match.home_score
    assert_equal 1, @match.away_score
    assert_equal({"sr:competitor:2674"=>1, "sr:competitor:2534"=>1}, @match.score)
    assert_equal({1=>{"home"=>1, "away"=>1, "sr:competitor:2674"=>1, "sr:competitor:2534"=>1}, 2=>{"home"=>0, "away"=>0, "sr:competitor:2674"=>0, "sr:competitor:2534"=>0}}, @match.scoring)
    assert_equal Time.utc(2017, 11, 03, 19, 30, 00), @match.scheduled
  end

  def test_it_gets_summary
    # get timeline
    # assert @match.coverage_info.coverage['key_events']
  end


end
