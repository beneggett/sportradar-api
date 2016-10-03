module Sportradar
  module Api
    class Nfl::Changelog < Data
      attr_accessor :response, :start_time, :end_time, :players, :games

      def initialize(data)
        @response = data
        @start_time = data["start_time"]
        @end_time = data["end_time"]
        @games = parse_into_array(selector: response["game"], klass: Sportradar::Api::Nfl::Game) if response["game"]
        @players = parse_into_array(selector: response["profiles"]["players"]["player"], klass: Sportradar::Api::Nfl::Player) if response["profiles"] && response["profiles"]["players"] && response["profiles"]["players"]["player"]
      end


    end
  end
end
