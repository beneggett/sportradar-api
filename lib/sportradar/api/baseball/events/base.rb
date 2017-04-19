module Sportradar
  module Api
    module Baseball
      class Event
        class Base < Data
          attr_accessor :response, :id, :hitter_id, :outcome

          def initialize(data, **opts)
            @response     = data#[data_key]
            @api          = opts[:api]
            @half_inning  = opts[:half_inning]

            # @id       = data["id"]
            # @type     = data['type']

            @pitches_hash = {}

            update(data)
          end

          def update(data, **opts)

          end

          def pitches
            []
          end
        end
      end
    end
  end
end
