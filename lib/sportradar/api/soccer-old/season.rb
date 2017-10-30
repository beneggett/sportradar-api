module Sportradar
  module Api
    class Soccer::Season < Data
      attr_accessor :response, :year, :statistics

      def initialize(data)
        @response = data
        @year = data["year"]
        @statistics = parse_into_array(selector: response["statistic"], klass: Sportradar::Api::Soccer::Statistic)  if response["statistic"]
      end

    end
  end
end
