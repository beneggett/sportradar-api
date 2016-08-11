module Sportradar
  module Api
    class Nfl::Hierarchy < Data
      attr_accessor :response, :id, :name, :alias, :divisions, :conferences, :teams

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        set_conferences
        set_divisions
        set_teams
      end

      private

      def set_divisions
        if @conferences.all? { |conference| conference.divisions }
          @divisions = @conferences.flat_map(&:divisions)
        elsif response["division"]
          if response["division"].is_a?(Array)
            @divisions = response["division"].map {|division| Sportradar::Api::Nfl::Division.new division }
          elsif response["division"].is_a?(Hash)
            @divisions = [ Sportradar::Api::Nfl::Division.new(response["division"]) ]
          end
        elsif response['conference']
          if response['conference'].all? { |conference| conference['division'] }
            @divisions = response['conference'].flat_map do |conference|
              conference['division'].map { |division| Sportradar::Api::Nfl::Division.new division }
            end
          end
        end
      end

      def set_teams
        if @divisions
          @teams = @divisions.flat_map(&:teams)
        elsif response['conference']
          response['conference'].flat_map do |conference|
            conference['division'].map do |division|
              if division["team"].is_a?(Array)
                @teams = division["team"].map {|team| Sportradar::Api::Nfl::Team.new team }
              elsif division["team"].is_a?(Hash)
                @teams = [ Sportradar::Api::Nfl::Team.new(division["team"]) ]
              end
            end
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
