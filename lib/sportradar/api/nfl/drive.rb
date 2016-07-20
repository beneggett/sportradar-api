module Sportradar
  module Api
    class Nfl::Drive < Data
      attr_accessor :response, :id, :sequence, :start_reason, :end_reason, :play_count, :duration, :first_downs, :gain, :penalty_yards, :scoring_drive, :quarter, :team, :plays

      def initialize(data)
        @response = data
        @id = data["id"]
        @sequence = data["sequence"]
        @start_reason = data["start_reason"]
        @end_reason = data["end_reason"]
        @play_count = data["play_count"]
        @duration = data["duration"]
        @first_downs = data["first_downs"]
        @gain = data["gain"]
        @penalty_yards = data["penalty_yards"]
        @scoring_drive = data["scoring_drive"]
        @quarter = Sportradar::Api::Nfl::Quarter.new data["quarter"] if data["quarter"]
        @team = Sportradar::Api::Nfl::Team.new data["team"] if data["team"]
        set_plays

      end

      private

      def set_plays
        if response["plays"] && response["plays"]["play"]
          if response["plays"]["play"].is_a?(Array)
            @plays = response["plays"]["play"].map {|play| Sportradar::Api::Nfl::Play.new play }
          elsif response["plays"]["play"].is_a?(Hash)
            @plays = [ Sportradar::Api::Nfl::Play.new(response["plays"]["play"]) ]
          end
        end
      end

    end
  end
end
