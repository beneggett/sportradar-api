module Sportradar
  module Api
    class Ncaafb::Game < Data
      attr_accessor :response, :id, :status, :reference, :number, :scheduled, :entry_mode, :venue, :home, :away, :broadcast, :number, :attendance, :utc_offset, :weather, :clock, :quarter, :summary, :situation, :last_event, :scoring, :scoring_drives, :quarters, :stats, :week, :season

      def initialize(data)
        @response = data
        @id = data["id"]

        # @status = data["status"]
        # @reference = data["reference"]
        # @number = data["number"]
        # @scheduled = Time.parse(data["scheduled"]) if data["scheduled"]
        # @week = Sportradar::Api::Nfl::Week.new data.dig("summary", "week") if data.dig("summary", "week")
        # @season = Sportradar::Api::Nfl::Season.new data.dig("summary", "season") if data.dig("summary", "season")
        # @entry_mode = data["entry_mode"]

        # # game boxscore
        # @number = data["number"]
        # @attendance = data["attendance"]
        # @utc_offset = data["utc_offset"]
        # @weather = data["weather"]
        # @clock = data["clock"]
        # if data["quarter"]
        #   @quarter = data["quarter"][0]
        #   quarter_data = data["quarter"][1].is_a?(Hash) ? [ data["quarter"][1] ] : data["quarter"][1]
        #   @quarters = quarter_data&.map { |hash| Sportradar::Api::Nfl::Quarter.new(hash) }
        # end
        # @summary = Sportradar::Api::Nfl::Summary.new data["summary"] if data["summary"]
        # @situation = Sportradar::Api::Nfl::Situation.new data["situation"] if data["situation"]
        # @last_event = Sportradar::Api::Nfl::Event.new data["last_event"]["event"] if data["last_event"] && data["last_event"]["event"]
        # @scoring = Sportradar::Api::Nfl::Scoring.new data["scoring"] if data["scoring"]
        # set_scoring_drives

        # location = data["summary"] || data
        # @venue = Sportradar::Api::Nfl::Venue.new data["venue"] || location["venue"] if data["venue"] || location["venue"]
        # @home = Sportradar::Api::Nfl::Team.new   data["home"]  || location["home"]  if data["home"]  || location["home"]
        # @away = Sportradar::Api::Nfl::Team.new   data["away"]  || location["away"]  if data["away"]  || location["away"]
        # @broadcast = Sportradar::Api::Nfl::Broadcast.new data["broadcast"] if data["broadcast"]
        # if data["team"]
        #   @stats = data["team"].map { |hash| [hash["id"], Sportradar::Api::Nfl::GameStatistic.new(hash)] }.to_h
        #   @home.stats = @stats[@home.id]
        #   @away.stats = @stats[@away.id]
        # end
      end

      # def current_score
      #   "#{summary.home.points}-#{summary.away.points}" if summary
      # end
      # def drives
      #   quarters&.flat_map(&:drives)
      # end
      # def plays
      #   drives&.flat_map(&:plays)
      # end

      private

      # def set_scoring_drives
      #   if response["scoring_drives"] && response["scoring_drives"]["drive"]
      #     if response["scoring_drives"]["drive"].is_a?(Array)
      #       @scoring_drives = response["scoring_drives"]["drive"].map {|scoring_drive| Sportradar::Api::Nfl::Drive.new scoring_drive }
      #     elsif response["scoring_drives"]["drive"].is_a?(Hash)
      #       @scoring_drives = [ Sportradar::Api::Nfl::Drive.new(response["scoring_drives"]["drive"]) ]
      #     end
      #   end
      # end

    end
  end
end
