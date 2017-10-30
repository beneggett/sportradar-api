require 'test_helper'

class Sportradar::Api::Soccer::StandingTest < Minitest::Test

  def setup
    @attrs = { "categories"=> {"category"=> [{"id"=>"ab5bfdbe-ed48-45e8-a6b9-eda3a8aaad3b", "name"=>"Mexico", "country_code"=>"MEX", "country"=>"Mexico", "tournament_group"=> {"id"=>"3baac5eb-2bd1-4561-ab76-b96d267dfe2a", "name"=>"Primera Division", "season_start"=>"2016-07-15T22:00:00Z", "season_end"=>"2017-06-24T21:59:00Z", "season"=>"2016", "reference_id"=>"sr:tournamentgroup:352", "tournament"=> [{"id"=>"3022ecee-5b9c-4e48-b6f8-7b0338e88b0f", "name"=>"Primera Division, Apertura", "season_id"=>"72a31835-d37e-470f-8370-b6b5e278fe60", "season_start"=>"2016-07-15T22:00:00Z", "season_end"=>"2017-06-24T21:59:00Z", "season"=>"2016", "type"=>"group", "reference_id"=>"sr:tournament:28", "team"=> [{"id"=>"50c96149-b75d-4961-83bf-516900533fb1", "name"=>"Tijuana", "full_name"=>"Club Tijuana", "alias"=>"TIJ", "country_code"=>"MEX", "country"=>"Mexico", "type"=>"team", "reference_id"=>"sr:team:36525", "rank"=>"1", "win"=>"7", "draw"=>"3", "loss"=>"1", "goals_for"=>"20", "goals_against"=>"9", "points"=>"24", "change"=>"1", "goals_diff"=>"11", "home"=> {"rank"=>"1", "change"=>"0", "win"=>"5", "draw"=>"0", "loss"=>"0", "goals_for"=>"11", "goals_against"=>"1", "points"=>"15"}, "away"=> {"rank"=>"2", "change"=>"5", "win"=>"2", "draw"=>"3", "loss"=>"1", "goals_for"=>"9", "goals_against"=>"8", "points"=>"9"}}] } ] } } ] } }
  end

  def test_it_initializes_a_soccer_standing
    data_object = Sportradar::Api::Soccer::Standing.new(@attrs)
    assert [:categories].all? { |e| data_object.attributes.include?(e) }
  end

end
