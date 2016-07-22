module Sportradar
  module Api
    class Nfl::Summary < Data
      attr_accessor :response, :season, :week, :venue, :home, :away

      def initialize(data)
        @response = data
        @season = Sportradar::Api::Nfl::Season.new data["season"] if data["season"]
        @week = Sportradar::Api::Nfl::Week.new data["week"] if data["week"]
        @venue = Sportradar::Api::Nfl::Venue.new data["venue"] if data["venue"]
        @home = Sportradar::Api::Nfl::Team.new data["home"] if data["home"]
        @away = Sportradar::Api::Nfl::Team.new data["away"] if data["away"]
      end

    end
  end
end
