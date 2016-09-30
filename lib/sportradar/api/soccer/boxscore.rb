module Sportradar
  module Api
    class Soccer::Boxscore < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        @matches = parse_into_array(selector: response["boxscore"]["matches"]["match"], klass: Sportradar::Api::Soccer::Match)  if response['boxscore'] && response['boxscore']['matches'] && response["boxscore"]["matches"]["match"]
      end

    end
  end
end
