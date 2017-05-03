module Sportradar
  module Api
    module Baseball
      class Error < Data
        attr_accessor :response, :id, :type, :last_name, :first_name, :preferred_name, :jersey_number

        def initialize(data, **opts)
          @response = data
          # @game     = opts[:game]

          update(data)
        end
        def update(data, **opts)
          @id             = data["id"]
          @type           = data["type"]
          @last_name      = data["last_name"]
          @first_name     = data["first_name"]
          @preferred_name = data["preferred_name"]
          @jersey_number  = data["jersey_number"]
        end

      end
    end
  end
end
