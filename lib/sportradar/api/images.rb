module Sportradar
  module Api
    class Images < Request
      attr_accessor :sport, :league, :access_level
      def initialize( sport, access_level = 't', league = nil)
        raise Sportradar::Api::Error::InvalidSport unless allowed_sports.include? sport
        @sport = sport
        raise Sportradar::Api::Error::InvalidLeague unless soccer_leagues.include?(league) || league.nil?
        @league = league

        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def player_manifests(year = Date.today.year)
        if league
          response = get request_url("#{league}/#{image_type}/players/#{year}/manifest")
        else
          response = get request_url("players/#{image_type}/manifests/all_assets")
        end
        Sportradar::Api::Images::AssetList.new response["assetlist"]  if response.success? && response["assetlist"]
      end

      alias_method :all_players, :player_manifests
      # Coach Manifests

      def coach_manifests
        raise Sportradar::Api::Error::InvalidLeague unless league.nil?
        response = get request_url("coaches/#{image_type}/manifests/all_assets")
        Sportradar::Api::Images::AssetList.new response["assetlist"]  if response.success? && response["assetlist"]
      end
      alias_method :all_coaches, :coach_manifests

      def venue_manifests
        raise Sportradar::Api::Error::InvalidLeague unless league.nil?
        response = get request_url("venues/manifests/all_assets")
        Sportradar::Api::Images::AssetList.new response["assetlist"]  if response.success? && response["assetlist"]
      end
      alias_method :all_venues, :venue_manifests

      # The Player Images, Coach Images, Venue Images APIs aren't really meant to be used directly, the manifests return an href path of an image we can pass it into the image_url method to get the entire image url
      def image_url(href)
        href.slice!(0) if href.chars.first == '/' # remove initial '/'
        set_base request_url(href) + api_key_query_string
      end
      alias_method :player_images, :image_url
      alias_method :coach_images, :image_url
      alias_method :venue_images, :image_url

      private

      def request_url(path)
        "/#{sport}-images-#{access_level}#{version}/#{provider}/#{path}"
      end

      def api_key
        if league
          if access_level == 'p'
            Sportradar::Api.api_key_params("images_#{league}", "production")
          else
            Sportradar::Api.api_key_params("images_#{league}")
          end
        else
          if access_level == 'p'
            Sportradar::Api.api_key_params("images_#{sport}", "production")
          else
            Sportradar::Api.api_key_params("images_#{sport}")
          end
        end
      end

      def api_key_query_string
        "?#{api_key.keys.first}=#{api_key.values.first}"
      end

      def provider
        if uses_v2_api?
          'usat'
        elsif uses_v3_api?
          'reuters'
        end
      end

      def version
        if uses_v2_api?
          Sportradar::Api.version('images')
        elsif uses_v3_api?
          3
        end
      end

      def image_type
        'headshots'
      end

      def uses_v2_api?
        v2_api_sports.include?(sport)
      end

      def uses_v3_api?
        v3_api_sports.include?(sport)
      end

      def allowed_access_levels
        ['p', 't']
      end

      def allowed_sports
        v2_api_sports + v3_api_sports
      end

      def v2_api_sports
        ['golf', 'mlb', 'nascar', 'nba', 'nfl', 'nhl', 'ncaafb', 'ncaamb', 'mls']
      end

      def v3_api_sports
        ['soccer', 'cricket', 'f1', 'rugby', 'tennis']
      end

      def soccer_leagues
        ['bundesliga', 'epl', 'serie-a', 'la-liga', 'ligue-1']
      end

      def additional_content_sports
        ['mlb', 'nba', 'nfl', 'nhl']
      end

    end
  end
end
