require 'test_helper'

class Sportradar::Api::Nfl::ChangelogTest < Minitest::Test

  def setup
    @attrs = {"start_time"=>"2016-10-02T04:00:00+00:00", "end_time"=>"2016-10-03T03:59:59+00:00", "profiles"=> {"players"=> {"player"=> [{"id"=>"18fc2ade-5106-491d-9e5f-97926e64459a", "full_name"=>"Josh Andrews", "last_modified"=>"2016-10-02T06:21:54+00:00"}, {"id"=>"2fd4116c-52de-41f5-9f30-16614eb424c4", "full_name"=>"Letroy Guion", "last_modified"=>"2016-10-02T06:21:56+00:00"}, {"id"=>"f14bf5cc-9a82-4a38-bc15-d39f75ed5314", "name"=>"Panthers", "alias"=>"CAR", "market"=>"Carolina", "last_modified"=>"2016-10-02T20:39:36+00:00"}]}}}
  end

  def test_it_initializes_an_nfl_changelog
    data_object = Sportradar::Api::Nfl::Changelog.new(@attrs)
    assert [:players].all? { |e| data_object.attributes.include?(e) }
  end

end
