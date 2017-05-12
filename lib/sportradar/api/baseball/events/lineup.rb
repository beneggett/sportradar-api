module Sportradar
  module Api
    module Baseball
      class Event
        class Lineup < Data
          attr_accessor :response, :id, :hitter_id, :outcome, :description, :player_id, :order, :position, :team_id, :last_name, :first_name, :preferred_name, :jersey_number

          def initialize(data, **opts)
            @response       =  data
            @id             =  data["id"]
            @player_id      =  data["player_id"]
            @order          =  data["order"]
            @position       =  data["position"]
            @team_id        =  data["team_id"]
            @last_name      =  data["last_name"]
            @first_name     =  data["first_name"]
            @preferred_name =  data["preferred_name"]
            @jersey_number  =  data["jersey_number"            ]

            update(data)
          end

          def update(data, **opts)
            @description = data['description'] if data['description']
          end

          def data_key
            'lineup'
          end

        end
      end
    end
  end
end



