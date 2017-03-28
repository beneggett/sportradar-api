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

          @at_bats_hash = {} if data['events'].first["at_bat"].present?

          update(data)

        end

        def update(data, **opts)
          @half     = data['half']
          @events   = data['events'] # contains at-bats, lineup changes, who knows what else
          binding.pry
          # @lineup   = parse_lineup(@events) if @events.first["lineup"] where does this actually go??
          @at_bats   = parse_at_bat(@events) if @events.first["at_bat"].present?

        end

        def at_bats
          @at_bats_hash.values
        end

        def parse_events events
          events.each do |event|
            case event.keys.first
            when "lineup"
              #do something with lineup item
            when "at_bat"
              #do something with at bat
            end
          end

          at_bats = events.select {|e| e.keys.first == 'lineup' }.flat_map {|e| e.values }
        end

        def parse_at_bat events
          at_bats = events.select {|e| e.keys.first == 'at_bat' }.flat_map {|e| e.values }
          create_data(@at_bats_hash, at_bats, klass: AtBat, api: @api, half_inning: self)
        end
      end
    end
  end
end
