module Sportradar
  module Api
    class Soccer::Standing < Data
      attr_accessor :response, :categories

      def initialize(data)
        @response = data
        set_categories
      end

      private

      def set_categories
        if response["categories"] && response["categories"]["category"]
          if response["categories"]["category"].is_a?(Array)
            @categories = response["categories"]["category"].map {|x| Sportradar::Api::Soccer::Category.new x }
          elsif response["categories"]["category"].is_a?(Hash)
            @categories = [ Sportradar::Api::Soccer::Category.new(response["categories"]["category"]) ]
          end
        end
      end
    end
  end
end
