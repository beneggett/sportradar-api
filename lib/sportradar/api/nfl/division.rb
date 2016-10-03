module Sportradar
  module Api
    class Nfl::Division < Data
      attr_accessor :response, :id, :name, :alias, :teams

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        @teams = parse_into_array(selector: response["team"], klass: Sportradar::Api::Nfl::Team) if response["team"]
      end

    end
  end
end
