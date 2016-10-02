module Sportradar
  module Api
    class Nfl::LeagueDepthChart < Data
      include Enumerable
      attr_accessor :response, :season, :charts

      def initialize(data)
        @response = data
        depth_chart_data = data["season"]['depth_charts']
        @season = Sportradar::Api::Nfl::Season.new data["season"] if data["season"]
        # @teams = depth_chart_data["team"].map {|team| Sportradar::Api::Nfl::Team.new team } if depth_chart_data["team"]
        @charts = depth_chart_data["team"].map {|team| Sportradar::Api::Nfl::TeamDepthChart.new(team, season) } if depth_chart_data["team"]
      end

      # id is preferred search, but we allow for team abbreviation too
      def team(id = nil, abbrev: nil)
        @charts.detect { |chart| chart.team_id == id || chart.abbrev == abbrev }
      end

      def each
        self.charts.each { |chart| yield chart }
      end

    end
  end
end
