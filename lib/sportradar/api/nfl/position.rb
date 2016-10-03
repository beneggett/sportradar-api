module Sportradar
  module Api
    class Nfl::Position < Data
      attr_accessor :response, :name, :players

      def initialize(data)
        @response = data
        @name = data["name"]
        @players = parse_into_array(selector: response["player"], klass: Sportradar::Api::Nfl::Player) if response["player"]
      end

    end
  end
end
