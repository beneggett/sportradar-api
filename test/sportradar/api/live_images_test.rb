require 'test_helper'

class Sportradar::Api::LiveImagesTest < Minitest::Test

  def test_it_accepts_a_valid_sport
    good = Sportradar::Api::LiveImages.new('nfl')
    assert_kind_of Sportradar::Api::LiveImages, good
    assert_raises Sportradar::Api::Error::InvalidSport do
      Sportradar::Api::LiveImages.new('make-believe')
    end
  end

  def test_it_accepts_a_valid_access_level
    good = Sportradar::Api::LiveImages.new('nfl', 'p')
    assert_kind_of Sportradar::Api::LiveImages, good
    assert_raises Sportradar::Api::Error::InvalidAccessLevel do
      Sportradar::Api::LiveImages.new('nfl', 'dumb')
    end
  end

  def test_it_makes_a_good_daily_manifest_request
    VCR.use_cassette("tests good daily manifest request") do
      request = Sportradar::Api::LiveImages.new('nfl', 't').daily_manifest(good_date)
      refute_kind_of Sportradar::Api::LiveImages, request
      assert_kind_of Sportradar::Api::Error, request # The code above will fail until I have a good api key
    end
  end

  def test_it_combines_an_image_url
    url = Sportradar::Api::LiveImages.new('nfl', 't').image_url('/cool')
    assert_equal url, "https://api.sportradar.us/nfl-liveimages-t1/usat/cool?api_key=#{api_key(:live_images_nfl)}"
  end


end
