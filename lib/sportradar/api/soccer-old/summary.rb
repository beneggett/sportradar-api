module Sportradar
  module Api
    class Soccer::Summary < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        @matches = parse_into_array(selector: response["summary"]["matches"]["match"], klass: Sportradar::Api::Soccer::Match)  if response['summary'] && response['summary']['matches'] && response["summary"]["matches"]["match"]
      end

    end
  end
end
