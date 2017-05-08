module Sportradar
  module Api
    module Baseball
      class Fielder < Data
        attr_accessor :response, :id, :starting_base, :ending_base, :outcome_id, :out

        def initialize(data, **opts)
          @response = data
          # @game     = opts[:game]

          update(data)
        end
        def update(data, **opts)
          @id             = data["id"]
          @type           = data["type"]
          @sequence       = data["sequence"]
          @last_name      = data["last_name"]
          @first_name     = data["first_name"]
          @preferred_name = data["preferred_name"]
          @jersey_number  = data["jersey_number"]
        end

      end
    end
  end
end
