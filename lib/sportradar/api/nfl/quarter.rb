module Sportradar
  module Api
    class Nfl::Quarter < Data
      attr_accessor :response, :id, :number, :sequence, :home_points, :away_points

      def initialize(data)
        @response = data
        @id = data["id"]
        @number = data["number"]
        @sequence = data["sequence"]
        @home_points = data["home_points"]
        @away_points = data["away_points"]
      end

    end
  end
end
