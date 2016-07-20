module Sportradar
  module Api
    class Nfl::Statistic < Data
      attr_accessor :response, :id, :sequence, :reference, :clock, :home_points, :away_points, :type, :play_clock, :wall_clock, :start_situation, :end_situation, :description, :alt_description, :statistics, :score, :scoring_play

      def initialize(data)
        @response = data
        @alt_description = data["alt_description"]
        @away_points = data["away_points"]
        @clock = data["clock"]
        @description = data["description"]
        @end_situation = Sportradar::Api::Nfl::Situation.new data["end_situation"] if data["end_situation"]
        @home_points = data["home_points"]
        @id = data["id"]
        @play_clock = data["play_clock"]
        @reference = data["reference"]
        @score = data["score"]
        @scoring_play = data["scoring_play"]
        @sequence = data["sequence"]
        @start_situation = Sportradar::Api::Nfl::Situation.new data["start_situation"] if data["start_situation"]
        @statistics = data["statistics"]
        @type = data["type"]
        @wall_clock = data["wall_clock"]
      end

    end
  end
end
