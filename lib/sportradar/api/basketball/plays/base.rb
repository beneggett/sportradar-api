module Sportradar
  module Api
    module Basketball
      class Play
        class Base < Data
          attr_accessor :response, :id, :clock, :event_type, :description, :statistics, :score, :team_id, :player_id, :quarter, :updated, :location, :possession, :on_court
          alias :type :event_type

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = data['id']

            update(data)
          end

          def game
            quarter.game
          end
          def scoring_play?
            points.nonzero?
          end

          def ==(other)
            id == other.id && description == other.description
          end

          def points
            0
          end

          def timeout?
            ["teamtimeout", "officialtimeout", "tvtimeout"].include? event_type
          end

          def update(data, **opts)
            @event_type  = data['event_type']  # "lineupchange",
            @clock       = data['clock']       # "12:00",
            @updated     = data['updated']     # "2016-10-26T00:07:52+00:00",
            @description = data['description'] # "Cavaliers lineup change (Richard Jefferson, Kyrie Irving, Mike Dunleavy, Channing Frye, LeBron James)",
            @attribution = data['attribution'] # {"name"=>"Cavaliers", "market"=>"Cleveland", "id"=>"583ec773-fb46-11e1-82cb-f4ce4684ea4c", "team_basket"=>"left"},
            @team_id     = data.dig('attribution', "id")
            @location    = data['location']    # {"coord_x"=>"0", "coord_y"=>"0"},
            @possession  = data['possession']  # {"name"=>"Knicks", "market"=>"New York", "id"=>"583ec70e-fb46-11e1-82cb-f4ce4684ea4c"},
            @on_court    = data['on_court']    # hash
            @statistics  = data['statistics']
          end

        end
      end
    end
  end
end
