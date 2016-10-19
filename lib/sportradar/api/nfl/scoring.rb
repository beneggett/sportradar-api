module Sportradar
  module Api
    class Nfl::Scoring < Data
      attr_accessor :response, :quarters

      def initialize(data)
        @response = data
        response['quarter'] = response['quarter'].select {|x| x.is_a? Hash } if response['quarter'].is_a?(Array) && response['quarter'].map(&:class).uniq.count > 1
        @quarters = parse_into_array(selector: response["quarter"], klass: Sportradar::Api::Nfl::Quarter)
      end

      def final
        "#{home}-#{away}"
      end

      def home
        quarters.map {|quarter| quarter.home_points.to_i }.reduce(:+)
      end

      def away
        quarters.map {|quarter| quarter.away_points.to_i }.reduce(:+)
      end
    end
  end
end
