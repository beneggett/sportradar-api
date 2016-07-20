module Sportradar
  module Api
    class Nfl::Coach < Data
      attr_accessor :response, :id, :full_name, :first_name, :last_name, :position

      def initialize(data)
        @response = data
        @id = data["id"]
        @full_name = data["full_name"]
        @first_name = data["first_name"]
        @last_name = data["last_name"]
        @position = data["position"]
      end

    end
  end
end
