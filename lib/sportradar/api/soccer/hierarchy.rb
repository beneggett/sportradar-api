module Sportradar
  module Api
    class Soccer::Hierarchy < Data
      attr_accessor :response, :categories

      def initialize(data)
        @response = data
        set_categories
      end

      private

      def set_categories
        if response["category"]
          if response["category"].is_a?(Array)
            @categories = response["category"].map {|x| Sportradar::Api::Soccer::Category.new x }
          elsif response["category"].is_a?(Hash)
            @categories = [ Sportradar::Api::Soccer::Category.new(response["category"]) ]
          end
        end
      end


    end
  end
end
