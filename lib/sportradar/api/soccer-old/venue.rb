module Sportradar
  module Api
    class Soccer::Venue < Data

      attr_accessor :id, :name, :country_code, :country, :city, :capacity, :coordinates, :reference_id, :response

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @country_code = data["country_code"]
        @country = data["country"]
        @city = data["city"]
        @capacity = data["capacity"]
        @coordinates = data["coordinates"]
        @reference_id = data["reference_id"]
      end

    end
  end
end
