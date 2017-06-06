module Sportradar
  module Api
    module Football
      class Event < Data
        attr_accessor :response, :id, :sequence, :reference, :clock, :type, :description, :alt_description

        def initialize(data, **opts)
          @response         = data
          @id               = data["id"]
          update(data, **opts)
        end
        def update(data, **opts)
          @sequence         = data["sequence"]
          @reference        = data["reference"]
          @clock            = data["clock"]
          @type             = data["type"]
          @description      = data["description"]
          @alt_description  = data["alt_description"]

          self
        end
      end

    end
  end
end
