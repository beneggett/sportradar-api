module Sportradar
  module Api
    class Nfl::TeamDepthChart < Data
      attr_accessor :response, :season

      # data.keys => ["offense", "defense", "special_teams", "name", "market", "alias", "id"]
      def initialize(data, season)
        @response = data
        @season = season
      end

      def offense
        @offense ||= Sportradar::Api::Nfl::DepthChart.new(response['offense'])
      end

      def defense
        @defense ||= Sportradar::Api::Nfl::DepthChart.new(response['defense'])
      end

      def special_teams
        @special_teams ||= Sportradar::Api::Nfl::DepthChart.new(response['special_teams'])
      end

      def team
        @team ||= Sportradar::Api::Nfl::Team.new(response).tap { |team| team.depth_chart = self }
      end

      private

      def set_charts
        [offense, defense, special_teams]
      end

    end
  end
end
