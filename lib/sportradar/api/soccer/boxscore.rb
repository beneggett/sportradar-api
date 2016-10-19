module Sportradar
  module Api
    class Soccer::Boxscore < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        @matches = parse_into_array(selector: response.dig("boxscore","matches","match"), klass: Sportradar::Api::Soccer::Match)
      end

    end
  end
end
