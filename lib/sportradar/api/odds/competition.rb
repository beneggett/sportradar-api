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
          create_data(@sport_events_hash, data["competition_sport_events_players_props"], klass: SportEvent, api: api)
          data
        end

        def fetch_player_props
          api.get_data(path_player_props)
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
