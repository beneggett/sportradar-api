module Sportradar
  module Api
    class Nfl::Season < Data
      attr_accessor :response, :id, :year, :type, :name, :weeks, :injuries, :team

      def initialize(data)
        @response = data
        @id = data["id"]
        @year = data["year"]
        @type = data["type"]
        @name = data["name"]
        @team = Sportradar::Api::Nfl::Team.new data["team"] if data["team"]
        @injuries = data["injuries"]["team"].map {|team| Sportradar::Api::Nfl::Team.new team } if data["injuries"] && data["injuries"]["team"]
        set_weeks
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

    end
  end
end
