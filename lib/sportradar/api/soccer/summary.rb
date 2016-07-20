module Sportradar
  module Api
    class Soccer::Summary < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        set_matches
      end

      private

      def set_matches
        if response["summary"]["matches"]["match"]
          if response["summary"]["matches"]["match"].is_a?(Array)
            @matches = response["summary"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x }
          elsif response["summary"]["matches"]["match"].is_a?(Hash)
            @matches = [ Sportradar::Api::Soccer::Match.new(response["summary"]["matches"]["match"]) ]
          end
        end
      end

    end
  end
end
