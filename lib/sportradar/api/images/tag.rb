module Sportradar
  module Api
    class Images::Tag < Data
      attr_accessor :response, :type, :value

      def initialize(data)
        @response = data
        @type = data["type"]
        @value = data["value"]
      end

    end
  end
end
