module Sportradar
  module Api
    class Images::Link < Data
      attr_accessor :response, :width, :height, :href

      def initialize(data)
        @response = data
        @width = data["width"]
        @height = data["height"]
        @href = data["href"]
      end

    end
  end
end
