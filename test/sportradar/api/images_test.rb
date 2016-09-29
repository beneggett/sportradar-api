require 'test_helper'

class Sportradar::Api::ImagesTest < Minitest::Test

  def test_it_accepts_a_valid_sport
    good = Sportradar::Api::Images.new('nfl')
    assert_kind_of Sportradar::Api::Images, good
    assert_raises Sportradar::Api::Error::InvalidSport do
      Sportradar::Api::Images.new('make-believe')
    end
  end

  def test_it_accepts_a_valid_league
    good = Sportradar::Api::Images.new('soccer', 't', 'epl')
    assert_kind_of Sportradar::Api::Images, good
    assert_raises Sportradar::Api::Error::InvalidLeague do
      Sportradar::Api::Images.new('soccer', 't', 'dumb')
    end
  end

  def test_it_accepts_a_valid_access_level
    good = Sportradar::Api::Images.new('nfl', 'p')
    assert_kind_of Sportradar::Api::Images, good
    assert_raises Sportradar::Api::Error::InvalidAccessLevel do
      Sportradar::Api::Images.new('nfl', 'dumb')
    end
  end

  def test_it_makes_a_good_player_manifests_request
    VCR.use_cassette("tests good player manifests request") do
      request = Sportradar::Api::Images.new('nfl', 't').player_manifests
      refute_kind_of Sportradar::Api::Images, request
      assert_kind_of Sportradar::Api::Error, request # The code above will fail until I have a good api key
    end
  end

  def test_it_makes_a_good_player_manifests_request_for_a_league
    VCR.use_cassette("tests good player manifests request for a league") do
      request = Sportradar::Api::Images.new('soccer', 't', 'epl').player_manifests
      refute_kind_of Sportradar::Api::Images, request
      assert_kind_of Sportradar::Api::Error, request # The code above will fail until I have a good api key
    end
  end

  def test_it_makes_a_good_coach_manifests_request
    VCR.use_cassette("tests good coach manifests request") do
      request = Sportradar::Api::Images.new('nfl', 't').coach_manifests
      refute_kind_of Sportradar::Api::Images, request
      assert_kind_of Sportradar::Api::Error, request # The code above will fail until I have a good api key
    end
  end

  def test_it_makes_a_good_venue_manifests_request
    VCR.use_cassette("tests good venue manifests request") do
      request = Sportradar::Api::Images.new('nfl', 't').venue_manifests
      refute_kind_of Sportradar::Api::Images, request
      assert_kind_of Sportradar::Api::Error, request # The code above will fail until I have a good api key
    end
  end

  def test_it_combines_an_image_url
    url = Sportradar::Api::Images.new('nfl', 't').image_url('/cool')
    assert_equal url, "https://api.sportradar.us/nfl-images-t2/usat/cool?api_key=#{api_key(:images_nfl)}"
  end


end
