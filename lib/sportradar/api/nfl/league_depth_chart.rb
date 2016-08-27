module Sportradar
  module Api
    class Nfl::LeagueDepthChart < Data
      attr_accessor :response, :season, :charts

      def initialize(data)
        @response = data
        depth_chart_data = data["season"].delete('depth_charts')
        @season = Sportradar::Api::Nfl::Season.new data["season"] if data["season"]
        # @teams = depth_chart_data["team"].map {|team| Sportradar::Api::Nfl::Team.new team } if depth_chart_data["team"]
        @charts = depth_chart_data["team"].map {|team| Sportradar::Api::Nfl::TeamDepthChart.new(team, season) } if depth_chart_data["team"]
      rescue => e
        binding.pry
      end

    end
  end
end
