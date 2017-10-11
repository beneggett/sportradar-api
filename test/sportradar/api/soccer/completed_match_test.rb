require 'test_helper'

class Sportradar::Api::Soccer::CompletedMatchTest < Minitest::Test

  def setup
    data = {"id"=>"sr:match:11854838"}
    @match = Sportradar::Api::Soccer::Match.new(data, league_group: 'eu')
  end

  def test_it_initializes_a_match
    assert_instance_of Sportradar::Api::Soccer::Match, @match
    assert_equal 'eu', @match.league_group
    assert_equal "sr:match:11854838", @match.id
  end

  def test_it_gets_summary
    get_summary
    assert_equal "ended", @match.match_status
    assert_equal "closed", @match.status
    assert_instance_of Sportradar::Api::Soccer::Venue, @match.venue
    assert_equal Time.utc(2017, 7, 19, 17, 30, 00), @match.scheduled
    assert_equal "sr:competitor:2402", @match.winner_id
    assert_equal 1, @match.home_score
    assert_equal 2, @match.away_score
    assert_equal "sr:competitor:1284", @match.aggregate_winner_id
    assert_equal 4, @match.aggregate_home_score
    assert_equal 3, @match.aggregate_away_score
    assert_equal "Lardot, Jonathan", @match.referee.name
    assert_equal "good", @match.weather_info.pitch
    # assert @match.coverage_info.coverage['key_events']
  end

  def test_it_gets_timeline
    get_timeline
    test_it_gets_summary
    assert_equal 152, @match.timeline.size
    assert_equal 64, @match.timeline("throw_in").size
    assert_equal 1, @match.timeline("match_started").size
  end

  def test_it_gets_lineups
    get_lineups
    assert_equal 2, @match.lineups.size
    assert_instance_of Sportradar::Api::Soccer::Lineup, @match.lineups('home')
  end

  def get_timeline
    VCR.use_cassette("soccer/#{@match.api.content_format}/match/completed_timeline") do
      @match.get_timeline
    end
  end

  def get_summary
    VCR.use_cassette("soccer/#{@match.api.content_format}/match/completed_summary") do
      @match.get_summary
    end
  end

  def get_lineups
    VCR.use_cassette("soccer/#{@match.api.content_format}/match/completed_lineups") do
      @match.get_lineups
    end
  end

end
