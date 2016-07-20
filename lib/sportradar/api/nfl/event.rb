module Sportradar
  module Api
    class Nfl::Event < Data
      attr_accessor :response, :id, :sequence, :reference, :clock, :type, :description, :alt_description

      def initialize(data)
        @response = data
        @id = data["id"]
        @sequence = data["sequence"]
        @reference = data["reference"]
        @clock = data["clock"]
        @type = data["type"]
        @description = data["description"]
        @alt_description = data["alt_description"]
      end

    end
  end
end
