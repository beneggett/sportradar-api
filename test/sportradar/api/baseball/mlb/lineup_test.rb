require 'test_helper'

class Sportradar::Api::Baseball::Mlb::LineupTest < Minitest::Test
  describe "lineup" do
    let(:game) { Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184") }
    let(:summary) { VCR.use_cassette('lineup game summary') { game.get_summary } }
    let(:pbp) { VCR.use_cassette('lineup game play by play') { game.get_pbp } }
    let(:lineup_update_hash) { {"lineup"=>
              {"description"=>"Robbie Ross Jr. (P) replaces Steven Wright (P).",
                         "id"=>"912e171b-b906-4214-a420-c1ca512a71a6",
                         "player_id"=>"7267e527-1ca0-4a94-b5a6-032e4769df48",
                         "order"=>0,
                         "position"=>1,
                         "team_id"=>"93941372-eb4c-4c40-aced-fe3267174393",
                         "last_name"=>"Ross Jr.",
                         "first_name"=>"Robert",
                         "preferred_name"=>"Robbie",
                         "jersey_number"=>"28"}} }

    it "creates a lineup from a summary" do
      lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
      lineup.update(summary, source: :summary)
      assert_equal lineup.home.length, 10
      assert_equal lineup.away.length, 10
      assert_equal lineup.home.first['preferred_name'], 'Craig'
    end
    
    it "creates a lineup from a pbp update" do
      lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
      lineup.update(summary, source: :summary)
      lineup.update_from_lineup_event(lineup_update_hash)
      assert_equal lineup.home.length, 10
      assert_equal lineup.away.length, 10
      assert_equal lineup.home.first['preferred_name'], 'Robbie'
    end

    it "sets the next upcoming batters" do
      lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
      lineup.update(summary, source: :summary)
      pbp
      next_batters = lineup.next_batters('home', 3)
      assert_equal next_batters.length, 3
      assert_equal next_batters.first['preferred_name'], 'Marco'
      assert_equal next_batters.second['preferred_name'], 'Craig'
      assert_equal next_batters.third['preferred_name'], 'Dustin'
    end
  end
end
