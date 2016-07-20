module Sportradar
  module Api
    class Nfl::Scoring < Data
      attr_accessor :response, :quarters

      def initialize(data)
        @response = data
        @quarters = data['quarter'].map { |quarter| Sportradar::Api::Nfl::Quarter.new quarter} if data['quarter']
      end

      def final
        "#{home}-#{away}"
      end

      def home
        quarters.map {|quarter| quarter['home_points'].to_i }.reduce(:+)
      end

      def away
        quarters.map {|quarter| quarter['away_points'].to_i }.reduce(:+)
      end
    end
  end
end
