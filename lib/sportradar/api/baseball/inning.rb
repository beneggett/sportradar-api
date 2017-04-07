module Sportradar
  module Api
    module Baseball
      class Inning < Data
        attr_accessor :response, :id, :game, :number, :sequence

        def initialize(data, **opts)
          # @response = data
          @api      = opts[:api]
          # @game     = opts[:game]

          @id       = data["id"]
          @number   = data['number']
          @sequence = data['sequence']

          @half_innings_hash = {}

          update(data)
        end
        def update(data, **opts)
          # update scoring
          # innings = data['innings'].each { |inning| inning['id'] = "#{data['id']}-#{inning['number']}" }
          create_data(@half_innings_hash, data.dig('halfs'), klass: HalfInning, api: @api, inning: self)
        end

        def half_innings
          @half_innings_hash.values
        end

        def events
          half_innings.flat_map(&:events)
        end

      end
    end
  end
end
