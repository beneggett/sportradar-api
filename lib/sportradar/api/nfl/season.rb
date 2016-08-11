module Sportradar
  module Api
    class Nfl::Season < Data
      attr_accessor :response, :id, :year, :type, :name, :weeks, :injuries, :team, :conferences

      def initialize(data)
        @response = data
        @id = data["id"]
        @year = data["year"]
        @type = data["type"]
        @name = data["name"]
        @team = Sportradar::Api::Nfl::Team.new(data["team"]) if data["team"].is_a?(Hash)
        @injuries = data["injuries"]["team"].map {|team| Sportradar::Api::Nfl::Team.new team } if data["injuries"] && data["injuries"]["team"]
        set_weeks
        set_conferences
      end

      private

      def set_weeks
        if response["week"]
          if response["week"].is_a?(Array)
            @weeks = response["week"].map {|week| Sportradar::Api::Nfl::Week.new week }
          elsif response["week"].is_a?(Hash)
            @weeks = [ Sportradar::Api::Nfl::Week.new(response["week"]) ]
          end
        end
      end

      def set_conferences
        if response["conference"]
          if response["conference"].is_a?(Array)
            @conferences = response["conference"].map {|conference| Sportradar::Api::Nfl::Conference.new conference }
          elsif response["conference"].is_a?(Hash)
            @conferences = [ Sportradar::Api::Nfl::Conference.new(response["conference"]) ]
          end
        end
      end

    end
  end
end
