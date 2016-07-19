module Sportradar
  module Api
    class Soccer::Schedule
      attr_accessor :response, :updated_at, :matches

      def initialize(data)
        @updated_at = data["schedule"]["generated"]
        @matches = data["schedule"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x } if data["schedule"]["matches"]["match"]
        @response = data
      end

    end
  end
end
