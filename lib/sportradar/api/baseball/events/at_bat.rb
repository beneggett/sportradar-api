module Sportradar
  module Api
    module Baseball
      class Event
        class AtBat < Data
          attr_accessor :response, :id, :event, :hitter_id, :outcome, :description

          def initialize(data, **opts)
            # @response = data
            @api      = opts[:api]
            @event    = opts[:event]

            @id       = data["id"]
            @type     = data['type']

            @pitches_hash = {}

            update(data)
          end

          def update(data, **opts)
            @description  = data['description'] if data['description']
            @hitter_id    = data['hitter_id']   if data['hitter_id']
            # this hasn't been checked yet
            # pitch events
            create_data(@pitches_hash, data.dig('events'), klass: Pitch, api: @api, at_bat: self)
          end

          def data_key
            'at_bat'
          end

          def over?
            pitches.last.is_ab_over
          end

          def pitches
            @pitches_hash.values
          end
        end
      end
    end
  end
end
