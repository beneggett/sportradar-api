module Sportradar
  module Api
    class Nfl::Game < Data
      attr_accessor :response, :id, :status, :reference, :number, :scheduled, :entry_mode, :venue, :home, :away, :broadcast, :number, :attendance, :utc_offset, :weather, :clock, :quarter, :summary, :situation, :last_event, :scoring, :scoring_drives

      def initialize(data)
        @response = data
        @id = data["id"]

        @status = data["status"]
        @reference = data["reference"]
        @number = data["number"]
        @scheduled = Time.parse(data["scheduled"]) if data["scheduled"]
        @entry_mode = data["entry_mode"]

        # game boxscore
        @number = data["number"]
        @attendance = data["attendance"]
        @utc_offset = data["utc_offset"]
        @weather = data["weather"]
        @clock = data["clock"]
        @quarter = data["quarter"]
        @summary = Sportradar::Api::Nfl::Summary.new data["summary"] if data["summary"]
        @situation = Sportradar::Api::Nfl::Situation.new data["situation"] if data["situation"]
        @last_event = Sportradar::Api::Nfl::Event.new data["last_event"]["event"] if data["last_event"] && data["last_event"]["event"]
        @scoring = Sportradar::Api::Nfl::Scoring.new data["scoring"] if data["scoring"]
        set_scoring_drives

        @venue = Sportradar::Api::Nfl::Venue.new data["venue"] if data["venue"]
        @home = Sportradar::Api::Nfl::Team.new data["home"] if data["home"]
        @away = Sportradar::Api::Nfl::Team.new data["away"] if data["away"]
        @broadcast = Sportradar::Api::Nfl::Broadcast.new data["broadcast"] if data["broadcast"]


      end

      private

      def set_scoring_drives
        if response["scoring_drives"] && response["scoring_drives"]["drive"]
          if response["scoring_drives"]["drive"].is_a?(Array)
            @scoring_drives = response["scoring_drives"]["drive"].map {|scoring_drive| Sportradar::Api::Nfl::Drive.new scoring_drive }
          elsif response["scoring_drives"]["drive"].is_a?(Hash)
            @scoring_drives = [ Sportradar::Api::Nfl::Drive.new(response["scoring_drives"]["drive"]) ]
          end
        end
      end

    end
  end
end
