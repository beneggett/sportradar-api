require 'test_helper'

class Sportradar::Api::Baseball::Mlb::LineupTest < Minitest::Test
  describe "lineup" do
    let(:game) { Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184") }
    let(:summary) { VCR.use_cassette('lineup game summary') { game.get_summary } }

    it "creates a lineup from a summary" do
      lineup = Sportradar::Api::Baseball::Lineup.new(home_team: summary['home'], away_team: summary['away'])
      assert_equal lineup.home.length, 10
      assert_equal lineup.away.length, 10
      assert_equal lineup.home.first['preferred_name'], 'Craig'
    end

    it "sets the next upcoming batters" do
      lineup = Sportradar::Api::Baseball::Lineup.new(home_team: summary['home'], away_team: summary['away'])
      next_batters = lineup.next_batters('home', 8, 3)
      assert_equal next_batters.length, 3
      assert_equal next_batters.first['preferred_name'], 'Marco'
      assert_equal next_batters.second['preferred_name'], 'Craig'
      assert_equal next_batters.third['preferred_name'], 'Dustin'
    end
  end
end
