module Sportradar
  module Api
    module Baseball
      class Event
        class AtBat < Data
          attr_accessor :response, :id, :event, :hitter_id, :hitter_hand, :pitcher_id, :pitcher_hand, :outcome, :description

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]
            @event    = opts[:event]

            @id       = data["id"]
            @type     = data['type']

            @pitches_hash = {}

            update(data)
          end

          # def ==(other)
          #   return false if other.nil?
          #   @id == other.id && pitches == other.pitches
          # end
          def outcome_id
            pitches.last&.outcome_id
          end

          def outcome
            pitches.last&.outcome
          end

          def hit?
            single? || double? || triple? || homerun?
          end

          def single?
            outcome.to_s.include?('Single')
          end

          def double?
            outcome.to_s.include?('Double')
          end

          def triple?
            outcome.to_s.include?('Triple')
          end

          def homerun?
            pitches.last&.homerun?
          end

          def strikeout?
            pitches.last&.count.dig('strikes') == 3
          end

          def update(data, **opts)
            @description  = data['description'] if data['description']
            @hitter_id    = data['hitter_id']   if data['hitter_id']
            @pitcher_id   = data['pitcher_id']  if data['pitcher_id']
            @hitter_hand    = data['hitter_hand']   if data['hitter_hand']
            @pitcher_hand   = data['pitcher_hand']  if data['pitcher_hand']
            # this hasn't been checked yet
            # pitch events
            pitches = data.dig('events').select {|pitch| pitch["type"] == 'pitch' }
            create_data(@pitches_hash, pitches, klass: Pitch, api: @api, at_bat: self)
          end

          def data_key
            'at_bat'
          end

          def over?
            pitches.last&.is_ab_over
          end


          def pitches
            @pitches_hash.values
          end
        end

      end
    end
  end
end
