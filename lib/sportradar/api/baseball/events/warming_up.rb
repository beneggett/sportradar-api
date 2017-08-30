module Sportradar
  module Api
    module Baseball
      class Event
        class WarmingUp < Data
          attr_accessor :response, :id, :first_name, :last_name, :player_id, :team_id

          def initialize(data, **opts)
            @response       = data
            # @api          = opts[:api]
            # @half_inning  = opts[:half_inning]
            @event          = opts[:event]
            @id             = data["id"]
            @type           = data['type']
            @first_name     = data['first_name'] if data['first_name']
            @last_name      = data['last_name'] if data['last_name']
            @player_id      = data['player_id'] if data['player_id']
            @team_id        = data['team_id'] if data['team_id']
            @preferred_name = data['preferred_name'] if data['preferred_name']
            update(data)
          end

          def description
            "#{(@preferred_name || @first_name)} #{@last_name} is now warming up in the bullpen."
          end

          def update(data, **opts)
            # parse pitches
          end

          def data_key
            'warming_up'
          end

        end
      end
    end
  end
end
