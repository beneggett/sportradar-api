module Sportradar
  module Api
    module Baseball
      class HalfInning < Data
        attr_accessor :response, :id, :inning, :type

        def initialize(data, **opts)
          # @response = data
          @api      = opts[:api]
          # @inning   = opts[:inning]
          @id       = data["id"]

          @events_hash = {}

          update(data)

        end

        def update(data, **opts)
          @half     = data['half']

          create_data(@events_hash, data['events'], klass: Event, api: @api, half_inning: self)
        end

        def atbats
          events_by_klass(AtBat)
        end

        def lineup_changes
          events_by_klass(LineupChange)
        end

        def events
          @events_hash.values
        end

        private def events_by_klass(klass)
          @events_hash.each_value.grep(klass)
        end

      end
    end
  end
end
