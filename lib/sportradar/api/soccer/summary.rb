module Sportradar
  module Api
    class Soccer::Summary
      attr_accessor :response, :updated_at, :matches

      def initialize(data)
        @updated_at = data["summary"]["generated"]
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
