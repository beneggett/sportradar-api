module Sportradar
  module Api
    class Broadcast < Data
      attr_accessor :response, :network

      def initialize(data)
        @response = data
        @network = data["network"]
      end

    end
  end
end
