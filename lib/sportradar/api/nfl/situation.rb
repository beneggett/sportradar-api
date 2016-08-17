module Sportradar
  module Api
    class Nfl::Situation < Data
      attr_accessor :response, :clock, :down, :yfd, :possession, :location, :team_id

      def initialize(data)
        @response = data
        @clock = data["clock"]
        @down = data["down"]
        @yfd = data["yfd"]
        @possession = OpenStruct.new data["possession"] if data["possession"]
        @location = OpenStruct.new data["location"] if data["location"]
        @team_id = possession.id if possession
      end

    end
  end
end
