module Sportradar
  module Api
    module Football
      class Ncaafb
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

            create_data(@plays_hash,  data['actions'],  klass: Play,  api: api, game: self) if data['actions']
            create_data(@events_hash, data['events'],   klass: Event, api: api, game: self) if data['events']

            self
          end


        end
      end
    end
  end
end
