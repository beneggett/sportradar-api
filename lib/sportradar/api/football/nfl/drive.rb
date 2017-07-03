module Sportradar
  module Api
    module Football
      class Nfl
        class Drive < Sportradar::Api::Football::Drive
          attr_reader :type

          def initialize(data, **opts)
            @response      = data
            @id            = data["id"]
            @api           = opts[:api]
            @plays_hash    = {}
            @events_hash   = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @type           = data['type']
            @team           = data['team']
            @clock          = data['clock']

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

            things = (Array(data['events']) + Array(data['actions'])).group_by { |hash| hash['type'] }

            create_data(@plays_hash,  things['play'],  klass: Play,  api: api, game: self) if things['play']
            create_data(@events_hash, things['event'], klass: Event, api: api, game: self) if things['setup']
            create_data(@events_hash, things['event'], klass: Event, api: api, game: self) if things['event']

            self
          end

        end
      end
    end
  end
end
