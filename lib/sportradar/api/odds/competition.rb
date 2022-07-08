module Sportradar
  module Api
    module Odds
      class Competition < Data
        attr_accessor :response, :api, :id, :name, :gender


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @id       = data['id']

          @name         = data['name']
          @gender       = data['gender']
          @has_markets      = data['markets']       # boolean
          @has_futures      = data['futures']       # boolean
          @has_player_props = data['player_props']  # boolean

          @sport_events_hash = {}
        end

        def update(data, **opts)

        end

        def sport_events
          @sport_events_hash.values
        end

        def get_player_props
          data = fetch_player_props
          prop_data = if data["competition_sport_events_players_props"].size == 10
            arr = data["competition_sport_events_players_props"]
            data = fetch_player_props(start: 10)
            arr += data["competition_sport_events_players_props"]
            if data["competition_sport_events_players_props"].size == 10
              data = fetch_player_props(start: 20)
              arr += data["competition_sport_events_players_props"]
            end
          else
            data["competition_sport_events_players_props"]
          end
          create_data(@sport_events_hash, prop_data, klass: SportEvent, api: api)
          data
        end

        def fetch_player_props(params = {})
          api.get_data(path_player_props, params)
        end

        # url path helpers
        def path_base
          "competitions/#{id}"
        end

        def path_player_props
          "#{path_base}/players_props"
        end

        def path_player_props
          "#{path_base}/players_props"
        end

      end
    end
  end
end
