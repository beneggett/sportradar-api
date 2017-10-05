module Sportradar
  module Api
    class Soccer::Statistic < Data
      attr_accessor :response, :year, :statistics

      def initialize(data)
        @response = data
        @year = data["year"]

      end

    end
  end
end
