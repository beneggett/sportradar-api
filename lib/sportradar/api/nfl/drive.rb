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
        @plays = parse_into_array(selector: response["play"], klass: Sportradar::Api::Nfl::Play) if response["play"]
        @plays ||= parse_into_array(selector: response["plays"]["play"], klass: Sportradar::Api::Nfl::Play) if response["plays"] && response["plays"]["play"]
      end

    end
  end
end
