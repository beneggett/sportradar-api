module Sportradar
  module Api
    module Baseball
      class HalfInning < Data
        attr_accessor :response, :id, :inning, :type, :half, :number

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @inning   = opts[:inning]
          @id       = data["id"]
          *@inning_id, @number, @half = data['id'].split('-')

          @events_hash = {}

          update(data)

        end

        def update(data, **opts)
          @half     = data['half']
          @events   = data['events'].map{ |hash| Event.new(hash, half_inning: self) }
          # create_data(@events_hash, data['events'], klass: Event, api: @api, half_inning: self)
        end

        def over?
          pitches.last&.count&.dig('outs') == 3
        end

        def pitches
          at_bats.flat_map(&:pitches)
        end

        def at_bats
          events.map(&:at_bat).compact
        end

        def lineup_changes
          # events_by_klass(LineupChange)
        end

        def events
          # @events_hash.values
          @events
        end

        def hits
          at_bats.flat_map(&:pitches).select {|pitch| pitch.is_hit }
        end

        def hit_count
          hits.count
        end

        def errors
          at_bats.flat_map(&:pitches).flat_map(&:errors).compact
        end

        def error_count
          errors.count
        end
        # private def events_by_klass(klass)
        #   @events_hash.each_value.grep(klass)
        # end

      end
    end
  end
end
