module Sportradar
  module Api
    class Odds < Request
      attr_accessor :access_level

      def initialize( access_level = 't')
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def odds
        get request_url, {format: 'none'}
      end
      private

      def request_url(path = nil)
        "/odds-#{access_level}#{version}"
      end

      def api_key
        Sportradar::Api.api_key_params("odds")
      end

      def version
        Sportradar::Api.version('odds')
      end

      def allowed_access_levels
        ['p', 's', 'b', 't']
      end

    end
  end
end
