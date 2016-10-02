module Sportradar
  module Api
    class Nfl::Week < Data
      attr_accessor :response, :id, :sequence, :title, :games

      def initialize(data)
        @response = data
        @id = data["id"]
        @sequence = data["sequence"]
        @title = data["title"]
        @games = parse_into_array(selector: response["game"], klass: Sportradar::Api::Nfl::Game) if response["game"]
      end

    end
  end
end
