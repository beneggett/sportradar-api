module Sportradar
  module Api
    module Baseball
      class Event
        class WarmingUp < Data
          attr_accessor :response, :id, :hitter_id, :outcome

          def initialize(data, **opts)
            @response     = data.first.last
            # @api          = opts[:api]
            # @half_inning  = opts[:half_inning]
            @event    = opts[:event]

            @id       = data["id"]
            @type     = data['type']

            update(data)
          end

          def update(data, **opts)
            # parse pitches
          end

          def data_key
            'warming_up'
          end

        end
      end
    end
  end
end
