require 'test_helper'

class Sportradar::Api::Baseball::Mlb::LineupTest < Minitest::Test
  describe "lineup" do
    describe "American" do
      let(:game) { Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184") }
      let(:summary) { VCR.use_cassette('lineup game summary') { game.get_summary } }
      let(:pbp) { VCR.use_cassette('lineup game play by play') { game.get_pbp } }
      let(:lineup_update_hash) { { 
                           "description"=>"Robbie Ross Jr. (P) replaces Steven Wright (P).",
                           "id"=>"912e171b-b906-4214-a420-c1ca512a71a6",
                           "player_id"=>"7267e527-1ca0-4a94-b5a6-032e4769df48",
                           "order"=>1,
                           "position"=>1,
                           "team_id"=>"93941372-eb4c-4c40-aced-fe3267174393",
                           "last_name"=>"Ross Jr.",
                           "first_name"=>"Robert",
                           "preferred_name"=>"Robbie",
                           "jersey_number"=>"28"}}

      it "creates a lineup from a summary" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        assert_equal lineup.home.length, 9
        assert_equal lineup.away.length, 9
        assert_equal 'Dustin', lineup.home.first['preferred_name']
      end
      
      it "creates a lineup from a pbp update" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        lineup.update_from_lineup_event(lineup_update_hash)
        assert_equal lineup.home.length, 9
        assert_equal lineup.away.length, 9
        assert_equal 'Robbie', lineup.home.first['preferred_name']
      end

      it "sets the next upcoming batters" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        pbp
        next_batters = lineup.next_batters('home', 3)
        assert_equal next_batters.length, 3
        assert_equal 'Marco', next_batters.first['preferred_name']
        assert_equal 'Dustin', next_batters.second['preferred_name']
        assert_equal 'Andrew', next_batters.third['preferred_name']
      end
    end
    describe "National" do
      let(:game) { Sportradar::Api::Baseball::Game.new('id' => "1977122c-6e03-4668-ac96-d2ce670f3e55") }
      let(:summary) { VCR.use_cassette('lineup game national summary') { game.get_summary } }
      let(:pbp) { VCR.use_cassette('lineup game national play by play') { game.get_pbp } }
      let(:lineup_update_hash) { {
                                    "description"=>"Fernando Salas (P) replaces Tommy Milone (P), batting 9th.",
                                    "id"=>"6a962ba1-2bbb-4ec1-8f0c-1d05cb980e6a",
                                    "player_id"=>"e878885a-8e8f-4b50-a130-15a08748e99e",
                                    "order"=>9,
                                    "position"=>1,
                                    "team_id"=>"f246a5e5-afdb-479c-9aaa-c68beeda7af6",
                                    "last_name"=>"Salas",
                                    "first_name"=>"Noel",
                                    "preferred_name"=>"Fernando",
                                    "jersey_number"=>"59" } }
      it "creates a lineup from a summary" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        pbp
        assert_equal 9, lineup.home.length
        assert_equal 9, lineup.away.length
        assert_equal 'José', lineup.home.first['preferred_name']
      end

      it "creates a lineup from a pbp update" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        lineup.update_from_lineup_event(lineup_update_hash)
        assert_equal 9, lineup.home.length
        assert_equal 9, lineup.away.length
        assert_equal 'Fernando', lineup.home[8]['preferred_name']
      end

      it "sets the next upcoming batters" do
        lineup = Sportradar::Api::Baseball::Lineup.new(nil, game: game)
        lineup.update(summary, source: :summary)
        pbp
        next_batters = lineup.next_batters('home', 3)
        assert_equal next_batters.length, 3
        assert_equal 'Juan', next_batters.first['preferred_name']
        assert_equal 'Rafael', next_batters.second['preferred_name']
        assert_equal 'José', next_batters.third['preferred_name']
      end
    end
  end
end
