module Sportradar
  module Api
    module Baseball
      class Event < Data
        attr_accessor :response, :id, :hitter_id, :outcome

        def initialize(data, **opts)
          @response     = data.first.last
          @api          = opts[:api]
          @half_inning  = opts[:half_inning]

          @id       = data["id"]
          @type     = data['type']

          update(data)
        end

        def update(data, **opts)

        end

        def pitches
          @pitches_hash.values
        end
      end
    end
  end
end
