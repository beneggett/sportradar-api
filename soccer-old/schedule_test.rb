require 'test_helper'

class Sportradar::Api::Soccer::ScheduleTest < Minitest::Test

  def setup
    @attrs = {"schedule"=> {"matches"=> {"match"=> [{"id"=>"3f7eb973-daab-49e5-b91a-6ab7cc1301a1", "status"=>"closed", "scheduled"=>"2016-09-30T00:00:00Z", "scratched"=>"false", "season_id"=>"42881571-769d-4877-9f85-71868dc510d1", "category"=> {"id"=>"c4ef0886-dfee-4725-81eb-1bb919be832a", "name"=>"International Clubs", "country_code"=>"XZ", "country"=>"International", }, "tournament_group"=> {"id"=>"dc3ea36c-1a29-41e3-b830-9dd2c685670a", "name"=>"CONCACAF CL", "season_start"=>"2016-08-01T22:00:00Z", "season_end"=>"2017-04-27T21:59:00Z", "season"=>"2016"}, "tournament"=> {"id"=>"c6b22c43-0e13-412a-9f0d-66ca1e3f9d51", "name"=>"CONCACAF Champions League, Group 5", "season_id"=>"42881571-769d-4877-9f85-71868dc510d1", "season_start"=>"2016-08-01T22:00:00Z", "season_end"=>"2017-04-27T21:59:00Z", "season"=>"2016", "type"=>"group", "type_group_id"=>"5", }, "home"=> {"id"=>"57ebb898-c0f3-473c-b8b6-47ed3473ad05", "name"=>"Police Utd", "full_name"=>"Police United", "alias"=>"POU", "country_code"=>"UNK", "country"=>"Unknown", "type"=>"team"}, "away"=> {"id"=>"d4fe17a0-745b-4abb-be38-20814a235258", "name"=>"Olimpia", "full_name"=>"CD Olimpia", "alias"=>"OLI", "country_code"=>"HND", "country"=>"Honduras", "type"=>"team"} } ]  } } }
  end

  def test_it_initializes_a_soccer_schedule
    data_object = Sportradar::Api::Soccer::Schedule.new(@attrs)
    assert [:matches].all? { |e| data_object.attributes.include?(e) }
  end

  def test_it_finds_a_league_by_name
    data_object = Sportradar::Api::Soccer::Schedule.new(@attrs)
    assert_equal data_object.league("CONCACAF CL").first.tournament_group.name, "CONCACAF CL"
  end

  def test_it_finds_available_leagues
    data_object = Sportradar::Api::Soccer::Schedule.new(@attrs)
    assert_includes data_object.available_leagues, "CONCACAF CL"
  end

end
