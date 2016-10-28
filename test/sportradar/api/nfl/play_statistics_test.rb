require 'test_helper'

class Sportradar::Api::Nfl::PlayStatisticsTest < Minitest::Test

  def setup
    @kick_attrs =  {"kick"=>
										 {"attempt"=>"1",
											"yards"=>"65",
											"gross_yards"=>"74",
											"touchback"=>"1",
											"team"=>{"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "reference"=>"5003", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"},
											"player"=>{"name"=>"Steven Hauschka", "jersey"=>"04", "reference"=>"00-0025944", "id"=>"40cda44b-2ee3-4ad1-834e-995e30db84d4", "position"=>"K"}}}
    
    @return_attrs = {"touchback"=>"1", "category"=>"kick_return", "team"=>{"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"}}

    @rush_attrs = {"attempt"=>"1","yards"=>"0","inside_20"=>"0","goaltogo"=>"0",
									 "team"=>{"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"},
									 "player"=>{"name"=>"David Johnson", "jersey"=>"31", "reference"=>"00-0032187", "id"=>"2c8670ae-0c23-4d20-9d2b-f4c3e25f8938", "position"=>"RB"}}

    @defense_attrs = [{"ast_tackle"=>"1",
											 "primary"=>"0",
											 "team"=>{"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "reference"=>"5003", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"},
											 "player"=>{"name"=>"Jeremy Lane", "jersey"=>"20", "reference"=>"00-0029295", "id"=>"88f23fe7-7bbe-4416-a98c-371d1f4d4f70", "position"=>"CB"}},
											{"ast_tackle"=>"1",
											 "primary"=>"0",
											 "team"=>{"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "reference"=>"5003", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"},
											 "player"=>{"name"=>"DeShawn Shead", "jersey"=>"35", "reference"=>"00-0029191", "id"=>"588022c3-f9c6-4f30-b4ea-a264f99fc997", "position"=>"DB"}}]

    @receive_attrs = {"target"=>"1",
											"reception"=>"1",
											"yards"=>"10",
											"yards_after_catch"=>"4",
											"inside_20"=>"0",
											"goaltogo"=>"0",
											"team"=>
											 {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"},
											"player"=>
											 {"name"=>"David Johnson","jersey"=>"31","reference"=>"00-0032187","id"=>"2c8670ae-0c23-4d20-9d2b-f4c3e25f8938","position"=>"RB"}}

		@punt_attrs =  {"attempt"=>"1",
										"yards"=>"33",
										"inside_20"=>"1",
										"team"=>
										 {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"},
										"player"=>
										 {"name"=>"Ryan Quigley","jersey"=>"09","reference"=>"00-0029493","id"=>"b4e5d1c1-5915-4326-b737-d6c796da0d75","position"=>"P"}}

		@penalty_attrs = {"penalty"=>"1",
											"yards"=>"10",
											"team"=>
											 {"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "reference"=>"5003", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"},
											"player"=>
											 {"name"=>"Garry Gilliam","jersey"=>"79","reference"=>"00-0030899","id"=>"a9fa2c9b-56df-470e-8f4f-682cdeb3dd7b","position"=>"T"}}

		@pass_attrs =  {"attempt"=>"1",
										"complete"=>"1",
										"yards"=>"17",
										"att_yards"=>"1",
										"firstdown"=>"1",
										"inside_20"=>"0",
										"goaltogo"=>"0",
										"team"=>
										 {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"},
										"player"=>
										 {"name"=>"Carson Palmer","jersey"=>"03","reference"=>"00-0021429","id"=>"57ad34b3-f60d-4b2d-9e01-3cb5a9451c37","position"=>"QB"}}

		@first_down_attrs =  {"category"=>"rush",
													"team"=>
													 {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"}}

		@field_goal_attrs =  {"attempt"=>"1",
													"att_yards"=>"39",
													"blocked"=>"1",
													"team"=>
													 {"name"=>"Cardinals", "market"=>"Arizona", "alias"=>"ARI", "reference"=>"4999", "id"=>"de760528-1dc0-416a-a978-b510d20692ff"},
													"player"=>
													 {"name"=>"Chandler Catanzaro","jersey"=>"07","reference"=>"00-0030896","id"=>"0d1171d4-c955-4966-9257-640b569866d1","position"=>"K"}}

		@down_conversion_attrs = {"down"=>"3",
															"attempt"=>"1",
															"complete"=>"0",
															"team"=>
															 {"name"=>"Seahawks", "market"=>"Seattle", "alias"=>"SEA", "reference"=>"5003", "id"=>"3d08af9e-c767-4f88-a7dc-b920c6d2b4a8"}}
    @data_object = Sportradar::Api::Nfl::PlayStatistics.new({"kick"=>@kick_attrs, "return" => @return_attrs, "rush" => @rush_attrs, "defense" => @defense_attrs,
																														 "receive" => @receive_attrs, "punt" => @punt_attrs, "penalty" => @penalty_attrs, "pass" => @pass_attrs,
																														 "first_down" => @first_down_attrs, "field_goal" => @field_goal_attrs, "down_conversion" => @down_conversion_attrs})
  end

  def test_nfl_player_initializes
    assert [ :response, :kick, :return, :rush, :defense, :receive, :punt, :penalty, :pass, :first_down, :field_goal, :defense, :down_conversion].all? { |e| @data_object.attributes.include?(e) }
  end

  def test_nfl_defense_returns_array
    assert_kind_of Array, @data_object.defense
  end
end
