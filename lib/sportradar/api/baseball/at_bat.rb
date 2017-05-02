module Sportradar
  module Api
    module Baseball
      class AtBat < Data
        attr_accessor :response, :id, :hitter_id, :outcome

        def initialize(data, **opts)
          # @response = data
          @api      = opts[:api]
          # @half_inning   = opts[:half_inning]

          @id       = data["id"]
          @type     = data['type']

          @pitches_hash = {}

          update(data)
        end
        def update(data, **opts)
          @description = data['description'] if data['description']

          create_data(@pitches_hash, data.dig('pitches'), klass: AtBat, api: @api, at_bat: self)
        end

        def pitches
          @pitches_hash.values
        end

      end
    end
  end
end
