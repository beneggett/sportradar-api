# TODO - rework this to v3 of API only
module Sportradar
  module Api
    class Images < Request
      attr_accessor :sport, :league, :access_level, :nfl_premium, :usat_premium, :event_id, :date, :live_image_request
      def initialize( sport, access_level: 't', league: nil, nfl_premium: false, usat_premium: false, event_id: nil, date: nil )
        raise Sportradar::Api::Error::InvalidSport unless allowed_sports.include? sport
        @sport = sport
        raise Sportradar::Api::Error::InvalidLeague unless soccer_leagues.include?(league) || league.nil?
        @league = league
        @nfl_premium = nfl_premium
        @usat_premium = usat_premium
        @event_id = event_id
        @date = date.strftime("%Y/%m/%d") if date
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def player_manifests(year = Date.today.year)
        if league
          if year != Date.today.year
            response = get request_url("#{league}/#{image_type}/players/#{year}/manifest")
          else
            response = get request_url("#{league}/#{image_type}/players/manifest")
          end
        elsif nfl_premium || usat_premium || sport == 'ncaafb' || sport == 'nba'
          year = Date.today.month < 8 ? Date.today.year - 1 : Date.today
          response = get request_url("#{image_type}/players/#{year}/manifest")
        else
          response = get request_url("players/#{image_type}/manifests/all_assets")
        end
        if response.success? && response["assetlist"]
          Sportradar::Api::Images::AssetList.new response["assetlist"]
        else
          response
        end
      end

      alias_method :all_players, :player_manifests
      # Coach Manifests

      def coach_manifests
        response = get request_url("coaches/#{image_type}/manifests/all_assets")
        if response.success? && response["assetlist"]
          Sportradar::Api::Images::AssetList.new response["assetlist"]
        else
          response
        end
      end
      alias_method :all_coaches, :coach_manifests

      def venue_manifests
        if version == 3
          response = get request_url("venues/manifest")
        else
          response = get request_url("venues/manifests/all_assets")
        end
        if response.success? && response["assetlist"]
          Sportradar::Api::Images::AssetList.new response["assetlist"]
        else
          response
        end
      end
      alias_method :all_venues, :venue_manifests

      # Event manifests will respont to either date or event_id
      def event_manifests
        # /[league]/[image_type]/events/[year]/[month]/[day]/manifest.[format]?api_key={your_api_key}
        raise Sportradar::Api::Error::InvalidType unless date.present? || event_id.present?
        @live_image_request = true
        if event_id.present?
          response = get request_url("actionshots/events/game/#{event_id}/manifest")
        elsif date.present?
          response = get request_url("actionshots/events/#{date}/manifest")
        end
        if response.success? && response["assetlist"]
          Sportradar::Api::Images::AssetList.new response["assetlist"]
        else
          response
        end

      end
      alias_method :all_events, :event_manifests
      alias_method :live_images, :event_manifests

      # The Player Images, Coach Images, Venue Images APIs aren't really meant to be used directly, the manifests return an href path of an image we can pass it into the image_url method to get the entire image url
      def image_url(href)
        @live_image_request = true if href.include?('actionshots')
        href.slice!(0) if href.chars.first == '/' # remove initial '/'
        set_base request_url(href) + api_key_query_string
      end
      alias_method :player_images, :image_url
      alias_method :coach_images, :image_url
      alias_method :venue_images, :image_url

      private

      def request_url(path)
        "/#{sport}-images-#{access_level}#{version}/#{provider}/#{( league + '/') if league}#{path}"
      end

      def api_key
        if league

          if access_level == 'p'
            Sportradar::Api.api_key_params("images_#{league}", "production")
          else
            Sportradar::Api.api_key_params("images_#{league}")
          end
        else
          if nfl_premium && access_level == 'p'
            Sportradar::Api.api_key_params("images_nfl_official_premium", "production")
          elsif nfl_premium
            Sportradar::Api.api_key_params("images_nfl_official_premium")
          elsif sport == 'mlb' && usat_premium && access_level == 'p'
            Sportradar::Api.api_key_params("images_mlb_premium", "production")
          elsif sport == 'mlb' && usat_premium
            Sportradar::Api.api_key_params("images_mlb_premium")
          elsif live_image_request && access_level == 'p'
            Sportradar::Api.api_key_params("live_images_#{sport}", "production")
          elsif live_image_request
            Sportradar::Api.api_key_params("live_images_#{sport}")
          elsif access_level == 'p'
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
        if nfl_premium
          'ap_premium'
        elsif usat_premium
          'usat_premium'
        elsif ['nba', 'nhl'].include?(sport)
          'getty_premium'
        else
          'usat'
          # REUTERS IS JUST FOR SOCCER sport == 'mlb' ? 'usat' : 'reuters'
        end
      end

      def version
        # if uses_v3_api? || nfl_premium || usat_premium || sport == 'nba'
        #   3
        # elsif uses_v2_api?
        #   Sportradar::Api.version('images')
        # end
        3
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
        v2_api_sports + v3_api_sports + soccer_leagues
      end

      def v2_api_sports
        ['golf',  'nascar', 'nba', 'nfl', 'nhl', 'ncaamb', 'mls']
      end

      def v3_api_sports
        ['mlb', 'soccer', 'cricket', 'f1', 'rugby', 'tennis', 'ncaafb', 'nba' ]
      end

      def soccer_leagues
        ['bundesliga', 'epl', 'serie-a', 'la-liga', 'ligue-1']
      end

      # Was going to use this to prevent access to venues/coaches for sports that aren't this
      # def additional_content_sports
      #   ['mlb', 'nba', 'nfl', 'nhl']
      # end

    end
  end
end
