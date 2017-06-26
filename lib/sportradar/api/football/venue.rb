module Sportradar
  module Api
    module Football
      class Venue < Data
        attr_accessor :response, :id, :name, :city, :state, :country, :zip, :address, :capacity, :surface, :roof_type, :timezone

        def initialize(data)
          @response  = data
          @id        = data["id"]
          @name      = data["name"]
          @city      = data["city"]
          @state     = data["state"]
          @country   = data["country"]
          @zip       = data["zip"]
          @address   = data["address"]
          @capacity  = data["capacity"]
          @timezone  = data['timezone']
          @surface   = data["surface"]
          @roof_type = data["roof_type"]
        end

      end
    end
  end
end
