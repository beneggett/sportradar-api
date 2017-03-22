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
          create_data(@half_innings_hash, data.dig('inning_half'), klass: HalfInning, api: @api, inning: self)
        end

        def half_innings
          @half_innings_hash.values
        end

      end
    end
  end
end
