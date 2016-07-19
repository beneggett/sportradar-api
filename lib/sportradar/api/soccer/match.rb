module Sportradar
  module Api
    class Soccer::Match

      attr_accessor :id, :status, :scheduled, :scratched, :season_id, :reference_id, :category, :tournament_group, :tournament, :home, :away, :venue, :round, :coverage, :period, :clock, :referee, :facts, :response

      def initialize(data)
        @id = data["id"]
        @reference_id = data["reference_id"]
        @scheduled = Date.parse data["scheduled"]
        @scratched = data["scratched"] == "true"
        @season_id = data["season_id"]
        @status = data["status"]
        @category = OpenStruct.new data["category"]
        @coverage = OpenStruct.new data["coverage"]
        @round = OpenStruct.new data["round"]
        @tournament = OpenStruct.new data["tournament"]
        @tournament_group = OpenStruct.new data["tournament_group"]

        @away = Sportradar::Api::Soccer::Team.new data["away"]
        @home = Sportradar::Api::Soccer::Team.new data["home"]
        @venue = Sportradar::Api::Soccer::Venue.new data["venue"] if data["venue"]

        # Actual stats from match summary
        @period = data["period"]
        @clock = data["clock"]
        @referee = OpenStruct.new data["referee"] if data["referee"]
        @facts = data["facts"]["fact"].map {|fact| Sportradar::Api::Soccer::Fact.new  fact } if data["facts"]
        @response = data
      end

      def period_name
        period_names = {"P1" => "Period one", "H" => "Halftime", "P2" => "Period two", "PX1" => "Pre-extra time one", "X1" => "Extra time one", "PX2" => "Pre-extra time two", "X2" => "Extra time two", "PP" => "Pre-penalty", "P" => "Penalty"}
        period_names[period] if period
      end

      def status_description
        status_descriptions = {"scheduled" =>  "The match is scheduled to be played", "inprogress" =>  "The match is currently in progress", "postponed" =>  "The match has been postponed to a future date", "delayed" =>  "The match has been temporarily delayed and will be continued", "canceled" =>  "The match has been canceled and will not be played", "closed" =>  "The match is over"}
        status_descriptions[status] if status
      end
    end
  end
end
