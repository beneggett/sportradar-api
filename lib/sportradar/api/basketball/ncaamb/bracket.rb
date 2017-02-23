module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Bracket < Data
          attr_accessor :response, :id, :name, :location, :start, :end

          def initialize(data, **opts)
            @response   = data
            @api        = opts[:api]
            @tournament = opts[:tournament]

            @id         = data['id']

            @games_hash = {}

            update(data)
          end

          def update(data, **opts)
            @response = data

            @name     = data['name']                  if data['name']
            @location = data['location']              if data['location']

            # update_games(data['games'])               if data['games']
            update_participants(data['participants']) if data['participants']
            self
          end

          # def games
          #   @games_hash.values
          # end

          # rounds are either bracketed (bracketed) or not (games)
          # def update_games(data)
          #   create_data(@games_hash, data, klass: Game, api: @api, season: self)
          # end

        end
      end
    end
  end
end
