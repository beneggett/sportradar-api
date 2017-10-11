module Sportradar
  module Api
    module Soccer
      class Venue < Data
        attr_reader :id, :name, :country_code, :country, :city, :capacity, :coordinates, :reference_id, :response

        def initialize(data)
          @response     = data
          @id           = data["id"]
          @name         = data["name"]
          @country_code = data["country_code"]
          @country      = data["country"] || data["country_name"]
          @city         = data["city"]    || data["city_name"]
          @capacity     = data["capacity"]
          @coordinates  = data["coordinates"] || data["map_coordinates"]
          @reference_id = data["reference_id"]
        end
      end

    end
  end
end
