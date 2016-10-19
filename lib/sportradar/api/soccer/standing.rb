module Sportradar
  module Api
    class Soccer::Standing < Data
      attr_accessor :response, :categories

      def initialize(data)
        @response = data
        @categories = parse_into_array(selector: response.dig("categories","category"), klass: Sportradar::Api::Soccer::Category)
      end

    end
  end
end
