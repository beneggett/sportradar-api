module Sportradar
  module Api
    class Images::Ref < Data
      attr_accessor :response, :sportradar_id, :sportsdata_id, :type, :name
      def initialize(data)
        @response = data
        @sportradar_id =  data["sportradar_id"]
        @sportsdata_id =  data["sportsdata_id"]
        @type =  data["type"]
        @name =  data["name"]
      end

    end
  end
end
