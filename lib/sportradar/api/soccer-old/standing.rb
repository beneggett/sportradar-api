module Sportradar
  module Api
    class Soccer::Standing < Data
      attr_accessor :response, :categories

      def initialize(data)
        @response = data
        @categories = parse_into_array(selector: response["categories"]["category"], klass: Sportradar::Api::Soccer::Category)  if response["categories"] && response["categories"]["category"]
      end

    end
  end
end
