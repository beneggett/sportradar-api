module Sportradar
  module Api
    class Nfl::Division < Data
      attr_accessor :response, :id, :name, :alias, :teams

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        set_teams
      end

      private

      def set_teams
        if response["team"]
          if response["team"].is_a?(Array)
            @teams = response["team"].map {|team| Sportradar::Api::Nfl::Team.new team }
          elsif response["team"].is_a?(Hash)
            @teams = [ Sportradar::Api::Nfl::Team.new(response["team"]) ]
          end
        end
      end

    end
  end
end
