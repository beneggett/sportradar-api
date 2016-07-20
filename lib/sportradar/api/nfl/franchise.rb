module Sportradar
  module Api
    class Nfl::Franchise < Data
      attr_accessor :response, :name, :alias


      def initialize(data)
        @response = data
        @name = data["name"]
        @alias = data["alias"]
      end

    end
  end
end
