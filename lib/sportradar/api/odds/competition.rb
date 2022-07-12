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
          prop_data = fetch_player_props.fetch('competition_sport_events_players_props', [])
          if prop_data.size == 10
            new_data = prop_data
            while new_data.size == 10
              new_data = fetch_player_props(start: prop_data.size).fetch('competition_sport_events_players_props', [])
              prop_data += new_data
            end
          end
          data = {'competition_sport_events_players_props' => prop_data }
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
