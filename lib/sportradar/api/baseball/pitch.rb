module Sportradar
  module Api
    module Baseball
      class Pitch < Data
        attr_accessor :response, :id, :outcome, :status

        def initialize(data, **opts)
          # @response = data
          @api      = opts[:api]
          # @half_inning   = opts[:half_inning]

          @id       = data["id"]

          @pitches_hash = {}

          update(data)
        end
        def update(data, **opts)
          @outcome_id   = data['outcome_id']  if data['outcome_id']
          @description  = data['description'] if data['description']

          @type         = data['pitch_type']  if data['pitch_type']
          @speed        = data['pitch_speed'] if data['pitch_speed']

          @runners  = parse_runners(data)   if data['runners']
          @errors   = parse_errors(data)    if data['errors']
          @fielders = parse_fielders(data)  if data['fielders']


          create_data(@pitches_hash, data.dig('pitches'), klass: AtBat, api: @api, at_bat: self)
        end

        def pitches
          @pitches_hash.values
        end

      end
    end
  end
end
