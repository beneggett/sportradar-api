module Sportradar
  module Api
    module Football
      class Drive < Data
        attr_accessor :response, :api, :id, :sequence, :start_reason, :end_reason, :play_count, :duration, :first_downs, :gain, :penalty_yards, :scoring_drive, :quarter, :team

        def self.new(data, **opts)
          if data['type'] == 'event'
            Event.new(data, **opts)
          else
            super
          end
        end

        def initialize(data, **opts)
          @id            = data["id"]
          @api           = opts[:api]
          @plays_hash    = {}
          @events_hash   = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @response       = data
          @type           = data['type']
          @team           = data['team']
          @clock          = data['clock']
          @overtime       = !!opts[:quarter]&.overtime? || @overtime

          @sequence       = data["sequence"]
          @start_reason   = data["start_reason"]
          @end_reason     = data["end_reason"]
          @play_count     = data["play_count"]
          @duration       = data["duration"]
          @first_downs    = data["first_downs"]
          @gain           = data["gain"]
          @penalty_yards  = data["penalty_yards"]
          @scoring_drive  = data["scoring_drive"]

          @quarter_data = data['quarter']
          @team_data    = data['team']

          handle_plays_and_events(data, **opts)

          self
        end

        def overtime?
          @overtime
        end

        def halftime?
          self.end_reason == 'End of Half'
        end

        def plays
          @plays_hash.values
        end

        def events
          @events_hash.values
        end

        def over?
          end_reason != 'UNKNOWN' && !end_reason.nil? # && !plays.last.parsed_ending # FIXME - maybe fix this. sim games have inconsistent data
        end

        def end_reason_possibilities
          [
            'UNKNOWN',
            'Touchdown',
            'Safety',
            'Field Goal',
            'Missed FG',
            'Blocked FG',
            'Blocked FG, Downs',
            'Blocked FG, Safety',
            'Punt',
            'Blocked Punt',
            'Blocked Punt, Downs',
            'Blocked Punt, Safety',
            'Downs',
            'Interception',
            'Fumble',
            'Fumble, Safety',
            'Muffed FG',
            'Muffed Punt',
            'Muffed Kickoff',
            'Kickoff',
            'Own Kickoff',
            'Onside Kick',
            'Kickoff, No Play',
            'End of Half',
            'End of Game',
          ]
        end
        def normalized_end_reason
          case end_reason
          when 'Touchdown', :pat
            'Touchdown'
          when 'Field Goal', 'Missed FG', "Blocked FG, Downs", 'Muffed FG', :fg
            'Field Goal'
          when 'Downs'
            'Downs'
          when 'Interception', 'Fumble', :fumble, :interception
            'Turnover'
          when 'Punt', 'Blocked Punt, Downs', 'Blocked Punt, Safety', :punt
            'Punt'
          when 'End of Half', :end_of_half
            'End of Half'
          when 'End of Game', :end_of_game
            'End of Game'
          when 'Safety', 'Blocked FG, Safety'
            'Safety'
          else
            'Other'
          end
        end
      end

    end
  end
end
