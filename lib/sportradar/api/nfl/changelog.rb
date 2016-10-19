module Sportradar
  module Api
    class Nfl::Changelog < Data
      attr_accessor :response, :start_time, :end_time, :players, :games

      def initialize(data)
        @response = data
        @start_time = data["start_time"]
        @end_time = data["end_time"]
        @games = parse_into_array(selector: response["game"], klass: Sportradar::Api::Nfl::Game)
        @players = parse_into_array(selector: response.dig("profiles","players","player"), klass: Sportradar::Api::Nfl::Player)
      end


    end
  end
end
