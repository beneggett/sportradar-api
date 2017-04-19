module Sportradar
  module Api
    module Baseball
      class Event
        class Lineup < Base
          attr_accessor :response, :id, :hitter_id, :outcome

          # def initialize(data, **opts)
          #   @response     = data.first.last
          #   @api          = opts[:api]
          #   @half_inning  = opts[:half_inning]

          #   @id       = data["id"]
          #   @type     = data['type']

          #   update(data)
          # end

          def update(data, **opts)
            # parse pitches
          end

          def data_key
            'lineup'
          end

        end
      end
    end
  end
end
