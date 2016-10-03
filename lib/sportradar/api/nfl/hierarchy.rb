module Sportradar
  module Api
    class Nfl::Hierarchy < Data
      attr_accessor :response, :id, :name, :alias, :divisions, :conferences, :teams

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        @conferences = parse_into_array(selector: data["conference"], klass: Sportradar::Api::Nfl::Conference)  if data["conference"]
        @divisions = conferences.flat_map(&:divisions) if conferences&.all? { |conference| conference.divisions }
        @divisions ||= parse_into_array(selector: data["division"], klass: Sportradar::Api::Nfl::Division)  if data["division"]
        @teams = @divisions.flat_map(&:teams) if divisions&.all? {|division| division.teams }
      end

    end
  end
end
