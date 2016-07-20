module Sportradar
  module Api
    class Nfl::Week < Data
      attr_accessor :response, :id, :sequence, :title, :games


      def initialize(data)
        @response = data
        @id = data["id"]
        @sequence = data["sequence"]
        @title = data["title"]
        @games = data["game"].map {|game| Sportradar::Api::Nfl::Game.new game } if data["game"]
      end

    end
  end
end
