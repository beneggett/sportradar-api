module Sportradar
  module Api
    class Ncaafb::Season < Data
      attr_accessor :response, :id, :year, :type, :name, :injuries, :team, :conferences, :divisions, :teams

      def initialize(data)
        @response = data
        @season   = response['season']
        @type     = response['type']

        # set_conferences
        # set_divisions
        # set_teams
      end

      # private

      def weeks
        @weeks ||= if response["week"]
          if response["week"].is_a?(Array)
            @weeks = response['week'].map { |week| Sportradar::Api::Ncaafb::Week.new(week) }
          elsif response["week"].is_a?(Hash)
            @weeks = [ Sportradar::Api::Ncaafb::Week.new(response["week"]) ]
          end
        end
      end

      # set_(conferences|divisions|teams) are all identical to the same methods in Hierarchy
      # There is likely more overlap between Sportradar's NFL standings and NFL hierarchy APIs
      # Eventually, these should be shared between classes
      # def set_conferences
      #   if response["conference"]
      #     if response["conference"].is_a?(Array)
      #       @conferences = response["conference"].map {|conference| Sportradar::Api::Nfl::Conference.new conference }
      #     elsif response["conference"].is_a?(Hash)
      #       @conferences = [ Sportradar::Api::Nfl::Conference.new(response["conference"]) ]
      #     end
      #   end
      # end

      # def set_divisions
      #   if conferences&.all? { |conference| conference.divisions }
      #     @divisions = conferences.flat_map(&:divisions)
      #   elsif response["division"]
      #     if response["division"].is_a?(Array)
      #       @divisions = response["division"].map {|division| Sportradar::Api::Nfl::Division.new division }
      #     elsif response["division"].is_a?(Hash)
      #       @divisions = [ Sportradar::Api::Nfl::Division.new(response["division"]) ]
      #     end
      #   end
      # end

      # def set_teams
      #   @teams = @divisions.flat_map(&:teams) if divisions&.all? {|division| division.teams }
      # end

    end
  end
end
