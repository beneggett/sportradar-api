module Sportradar
  module Api
    class Nfl::Position < Data
      attr_accessor :response, :name, :players

      def initialize(data)
        @response = data
        @name = data["name"]
        set_players
      end

      private

      def set_players
        if response["player"]
          if response["player"].is_a?(Array)
            @players = response["player"].map {|player| Sportradar::Api::Nfl::Player.new player }
          elsif response["player"].is_a?(Hash)
            @players = [ Sportradar::Api::Nfl::Player.new(response["player"]) ]
          end
        end
      end

    end
  end
end
