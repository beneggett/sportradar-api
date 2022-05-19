module Sportradar
  module Api
    module Odds
      class Sport < Data
        attr_accessor :response, :api, :id, :name, :type


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @id       = data['id']
          @name     = data['name']
          @type     = data['type']

          @competitions_hash = {}
        end

        def update(data, **opts)

        end


        def competitions
          @competitions_hash.values
        end

        def get_competitions
          data = api.get_data(path_competitions);
          create_data(@competitions_hash, data['competitions'], klass: Sport, api: api)
          data
        end

        # url path helpers
        def path_base
          "sports/#{id}"
        end

        def path_competitions
          "#{path_base}/competitions"
        end


      end
    end
  end
end
