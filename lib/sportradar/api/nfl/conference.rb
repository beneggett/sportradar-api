module Sportradar
  module Api
    class Nfl::Conference < Data
      attr_accessor :response, :id, :name, :alias, :divisions

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        set_divisions
      end

      private

      def set_divisions
        if response["division"]
          if response["division"].is_a?(Array)
            @divisions = response["division"].map {|division| Sportradar::Api::Nfl::Division.new division }
          elsif response["division"].is_a?(Hash)
            @divisions = [ Sportradar::Api::Nfl::Division.new(response["division"]) ]
          end
        end
      end

    end
  end
end
