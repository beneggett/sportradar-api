module Sportradar
  module Api
    module Baseball
      class Runner < Data
        attr_accessor :response, :id, :starting_base, :ending_base, :outcome_id, :out, :description, :fielders

        def initialize(data, **opts)
          @response = data
          # @game     = opts[:game]

          update(data)
        end
        def update(data, **opts)
          @id             = data["id"]
          @starting_base  = data["starting_base"]
          @ending_base    = data["ending_base"]
          @outcome_id     = data["outcome_id"]
          @out            = data["out"]
          @last_name      = data["last_name"]
          @first_name     = data["first_name"]
          @preferred_name = data["preferred_name"]
          @jersey_number  = data["jersey_number"]
          @description    = data['description']
          @fielders       = data['fielders'].map { |hash| Fielder.new(hash) } if data['fielders']
        end

      end
    end
  end
end
