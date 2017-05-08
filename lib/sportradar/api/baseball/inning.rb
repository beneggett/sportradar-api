module Sportradar
  module Api
    module Baseball
      class Inning < Data
        attr_accessor :response, :id, :game, :number, :sequence, :scoring

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @game     = opts[:game]

          @id       = data["id"]
          @number   = data['number']
          @sequence = data['sequence']

          parse_scoring(data['scoring']) if data['scoring']

          @half_innings_hash = {}

          update(data)
        end
        def update(data, **opts)
          # update scoring
          halfs = data['halfs'].each { |inning| inning['id'] = "#{data['id']}-#{inning['half']}" }
          create_data(@half_innings_hash, halfs, klass: HalfInning, api: @api, inning: self)
        end
        def parse_scoring(data)
          @scoring = data.each_with_object({}) { |(_, data), hash| hash[data['id']] = data['runs'].to_s } # from PBP
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
