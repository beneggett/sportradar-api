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
        @weeks = parse_into_array(selector: response["week"], klass: Sportradar::Api::Nfl::Week)  if response["week"]
        @conferences = parse_into_array(selector: response["conference"], klass: Sportradar::Api::Nfl::Conference)  if response["conference"]
        @divisions = conferences.flat_map(&:divisions) if conferences&.all? { |conference| conference.divisions }
        @divisions ||= parse_into_array(selector: response["division"], klass: Sportradar::Api::Nfl::Division)  if response["division"]
        @teams = @divisions.flat_map(&:teams) if divisions&.all? {|division| division.teams }
      end

    end
  end
end
