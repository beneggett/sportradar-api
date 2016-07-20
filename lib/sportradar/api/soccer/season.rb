module Sportradar
  module Api
    class Soccer::Season < Data
      attr_accessor :response, :year, :statistics

      def initialize(data)
        @response = data
        @year = data["year"]
        set_statistics

      end

      private

      def set_statistics
        if response["statistic"]
          if response["statistic"].is_a?(Array)
            @statistics = response["statistic"].map {|statistic| Sportradar::Api::Soccer::Statistic.new statistic }
          elsif response["statistic"].is_a?(Hash)
            @statistics = [ Sportradar::Api::Soccer::Statistic.new(response["statistic"]) ]
          end
        end
      end

    end
  end
end
