module Sportradar
  module Api
    class LiveImages < Request
      attr_accessor :sport, :access_level

      def initialize( sport, access_level = 't')
        raise Sportradar::Api::Error::InvalidSport unless allowed_sports.include? sport
        @sport = sport
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def daily_manifest(date = Date.today )
        response = get request_url("#{image_type }/#{date.to_s}/manifests/all_assets")
        if response.success? && response["assetlist"]
          Sportradar::Api::Images::AssetList.new response["assetlist"]
        else
          response
        end
      end
      alias_method :all_images, :daily_manifest

      # The Event images APIs aren't really meant to be used directly, the manifests return an href path of an image we can pass it into the image_url method to get the entire image url
      def image_url(href)
        href.slice!(0) if href.chars.first == '/'  # remove initial '/'
        set_base request_url(href) + api_key_query_string
      end

      private

      def request_url(path)
        "/#{sport}-liveimages-#{access_level}#{version}/#{provider}/#{path}"
      end

      def api_key
        if access_level == 'p'
          Sportradar::Api.api_key_params("live_images_#{sport}", "production")
        else
          Sportradar::Api.api_key_params("live_images_#{sport}")
        end

      end

      def api_key_query_string
        "?#{api_key.keys.first}=#{api_key.values.first}"
      end

      def provider
        'usat'
      end

      def version
        Sportradar::Api.version('live_images')
      end

      def image_type
        'news'
      end

      def allowed_access_levels
        ['p', 't']
      end

      def allowed_sports
        ['golf', 'mlb', 'nascar', 'nba', 'nfl', 'nhl', 'ncaafb', 'ncaamb', 'mls']
      end

    end
  end
end
