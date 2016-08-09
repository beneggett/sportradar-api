module Sportradar
  module Api
    class Nfl::Week < Data
      attr_accessor :response, :id, :sequence, :title, :games


      def initialize(data)
        @response = data
        @id = data["id"]
        @sequence = data["sequence"]
        @title = data["title"]
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

    end
  end
end
