module Sportradar
  module Api
    class Soccer::Boxscore < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        set_matches
      end

      private
      def set_matches
        if response['boxscore'] && response['boxscore']['matches'] && response["boxscore"]["matches"]["match"]
          if response["boxscore"]["matches"]["match"].is_a?(Array)
            @matches = response["boxscore"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x }
          elsif response["boxscore"]["matches"]["match"].is_a?(Hash)
            @matches = [ Sportradar::Api::Soccer::Match.new(response["boxscore"]["matches"]["match"]) ]
          end
        end
      end

    end
  end
end
