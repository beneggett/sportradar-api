module Sportradar
  module Api
    module Baseball
      class Event
        class Lineup < Data
          attr_accessor :response, :id, :hitter_id, :outcome, :description, :event, :player_id, :order, :position, :team_id, :last_name, :first_name, :preferred_name, :jersey_number

          def initialize(data, **opts)
            @response       =  data
            @event          =  opts[:event]
            @description    =  data["description"]
            @id             =  data["id"]
            @player_id      =  data["player_id"]
            @order          =  data["order"]
            @position       =  data["position"]
            @team_id        =  data["team_id"]
            @last_name      =  data["last_name"]
            @first_name     =  data["first_name"]
            @preferred_name =  data["preferred_name"]
            @jersey_number  =  data["jersey_number"]

            # update(data)
          end

          def update(data, **opts)
            # lineup = event.half_inning.inning.game.lineup
            # lineup.update_from_lineup_event(data)
          end

          def data_key
            'lineup'
          end

        end
      end
    end
  end
end



