module Sportradar
  module Api
    class Nfl::DepthChart < Data
      attr_accessor :response, :season, :teams

      def initialize(data)
        @response = data
        @season = Sportradar::Api::Nfl::Season.new data["season"] if data["season"]
        @teams = data["season"]["depth_charts"]["team"].map {|team| Sportradar::Api::Nfl::Team.new team } if data["season"]["depth_charts"]["team"]

      end

    end
  end
end
