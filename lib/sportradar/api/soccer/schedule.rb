module Sportradar
  module Api
    class Soccer::Schedule < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        @matches = data["schedule"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x } if data["schedule"]["matches"]["match"]
      end

    end
  end
end
