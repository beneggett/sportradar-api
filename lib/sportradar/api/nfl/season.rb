module Sportradar
  module Api
    class Nfl::Season < Data
      attr_accessor :response, :id, :year, :type, :name, :weeks, :injuries, :team, :conferences, :divisions, :teams

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
        set_divisions
        set_teams
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

      # set_(conferences|divisions|teams) are all identical to the same methods in Hierarchy
      # There is likely more overlap between Sportradar's NFL standings and NFL hierarchy APIs
      # Eventually, these should be shared between classes
      def set_conferences
        if response["conference"]
          if response["conference"].is_a?(Array)
            @conferences = response["conference"].map {|conference| Sportradar::Api::Nfl::Conference.new conference }
          elsif response["conference"].is_a?(Hash)
            @conferences = [ Sportradar::Api::Nfl::Conference.new(response["conference"]) ]
          end
        end
      end

      def set_divisions
        if conferences&.all? { |conference| conference.divisions }
          @divisions = conferences.flat_map(&:divisions)
        elsif response["division"]
          if response["division"].is_a?(Array)
            @divisions = response["division"].map {|division| Sportradar::Api::Nfl::Division.new division }
          elsif response["division"].is_a?(Hash)
            @divisions = [ Sportradar::Api::Nfl::Division.new(response["division"]) ]
          end
        end
      end

      def set_teams
        @teams = @divisions.flat_map(&:teams) if divisions&.all? {|division| division.teams }
      end

    end
  end
end
