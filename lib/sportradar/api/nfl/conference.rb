module Sportradar
  module Api
    class Nfl::Conference < Data
      attr_accessor :response, :id, :name, :alias, :divisions

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        @divisions = parse_into_array(selector: response["division"], klass: Sportradar::Api::Nfl::Division)
      end

    end
  end
end
