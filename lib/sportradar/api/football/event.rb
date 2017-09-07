module Sportradar
  module Api
    module Football
      class Event < Data
        attr_accessor :response, :id, :sequence, :reference, :clock, :type, :event_type, :description, :alt_description

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
          @event_type       = data["event_type"]
          @description      = data["description"] || data["summary"]
          @alt_description  = data["alt_description"]

          self
        end
        def plays
          []
        end
        def events
          [self]
        end
        def over?
          false # TODO
        end
        def halftime?
          false
        end
      end

    end
  end
end
