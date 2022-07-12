module Sportradar
  module Api
    module Odds
      class Base < Data
        attr_reader :api

        def initialize
          @api = self.class.api
          @books_hash = {}
          @sports_hash = {}
        end

        def books
          @books_hash.values
        end

        def sports
          @sports_hash.values
        end

        def get_books
          data = api.get_data(path_books);
          create_data(@books_hash, data['books'], klass: Book, api: api)
          data
        end

        def get_sports
          data = api.get_data(path_sports);
          create_data(@sports_hash, data['sports'], klass: Sport, api: api)
          data
        end

        def get_event_mappings
          data = api.get_data(path_event_mappings).fetch('mappings', [])
          if data.size == 1000
            new_data = data
            while new_data.size == 1000
              new_data = api.get_data(path_player_mappings, start: data.size).fetch('mappings', [])
              data += new_data
            end
          end
          {'mappings' => data }
        end

        def get_player_mappings
          data = api.get_data(path_player_mappings).fetch('mappings', [])
          if data.size == 1000
            new_data = data
            while new_data.size == 1000
              new_data = api.get_data(path_player_mappings, start: data.size).fetch('mappings', [])
              data += new_data
            end
          end
          {'mappings' => data }
        end

        def get_competitor_mappings
          data = api.get_data(path_competitor_mappings)
        end

        # url path helpers
        def path_base
          ""
        end

        def path_books
          "books"
        end

        def path_sports
          "sports"
        end

        def path_event_mappings
          'sport_events/mappings'
        end

        def path_player_mappings
          'players/mappings'
        end

        def path_competitor_mappings
          'competitors/mappings'
        end

        def self.api
          Api.new(base_path: api_base)
        end

      end
    end
  end
end
