module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Round < Data
          attr_accessor :response, :id, :name, :location, :start, :end

          def initialize(data, **opts)
            @response   = data
            @api        = opts[:api]
            @tournament = opts[:tournament]

            @id         = data['id']

            @games_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @response = data

            @name     = data['name']            if data['name']
            @sequence = data['sequence']        if data['sequence']

            update_games(data['games'])         if data['games']
            update_brackets(data['bracketed'])  if data['bracketed']
          end

          def games
            @games_hash.values
          end


          def update_games(data)
            create_data(@games_hash, data, klass: Game, api: @api, season: self)
          end

          def update_brackets(data)
            data.each do |hash|
              create_data(@games_hash, hash['games'], klass: Game, api: @api, round: self, tournament: @tournament)
              # @tournament.update_bracket(data['bracket'].merge('games' => data['games']))
            end
            # hash = {
            #   "bracket"=>{"id"=>"fc853dd0-4744-4735-9e16-5953a155dc1c", "name"=>"East Regional", "location"=>"Philadelphia, PA, USA"},
            #   'games' => [],
            # }

          end

        end
      end
    end
  end
end
