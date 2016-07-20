module Sportradar
  module Api
    class Nfl::Draft < Data
      attr_accessor :response, :year, :round, :number, :team

      def initialize(data)
        @response = data
        @year = data["year"]
        @round = data["round"]
        @number = data["number"]
        @team = Sportradar::Api::Nfl::Team.new data["team"] if data["team"]
      end

    end
  end
end
