module Sportradar
  module Api
    class Nfl::TeamDepthChart < Data
      include Enumerable
      attr_accessor :response, :season, :team_id, :abbrev

      # data.keys => ["offense", "defense", "special_teams", "name", "market", "alias", "id"]
      def initialize(data, season)
        @response = data
        @season = season
        @team_id = response['id']
        @abbrev = response['alias']
      end

      def offense
        @offense ||= Sportradar::Api::Nfl::DepthChart.new(response['offense']) if response['offense']
      end

      def defense
        @defense ||= Sportradar::Api::Nfl::DepthChart.new(response['defense']) if response['defense']
      end

      def special_teams
        @special_teams ||= Sportradar::Api::Nfl::DepthChart.new(response['special_teams']) if response['special_teams']
      end

      def team
        @team ||= Sportradar::Api::Nfl::Team.new(response).tap { |team| team.depth_chart = self }
      end

      def each
        [:offense, :defense, :special_teams].each { |type| yield type, send(type) }
      end

      # These aren't ever used, but handy if you need to invoke for testing
      # private

      # def set_charts
      #   [offense, defense, special_teams]
      # end

    end
  end
end
