module Sportradar
  module Api
    class Nfl::Changelog < Data
      attr_accessor :response, :start_time, :end_time, :players, :games

      def initialize(data)
        @response = data
        @start_time = data["start_time"]
        @end_time = data["end_time"]
        set_players
        set_games
      end

      private

      def set_games
        if response["game"]
          if response["game"].is_a?(Array)
            @games = response["game"].map {|game| Sportradar::Api::Nfl::Game.new game }
          elsif response["game"].is_a?(Hash)
            @games = [ Sportradar::Api::Nfl::Game.new(response["game"]) ]
          end
        end
      end


      def set_players
        if response["profiles"] && response["profiles"]["players"] && response["profiles"]["players"]["player"]
          if response["profiles"]["players"]["player"].is_a?(Array)
            @players = response["profiles"]["players"]["player"].map {|player| Sportradar::Api::Nfl::Player.new player }
          elsif response["profiles"]["players"]["player"].is_a?(Hash)
            @players = [ Sportradar::Api::Nfl::Player.new(response["profiles"]["players"]["player"]) ]
          end
        end
      end

    end
  end
end
