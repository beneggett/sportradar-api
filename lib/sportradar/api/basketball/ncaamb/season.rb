module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Season < Basketball::Season
          attr_accessor :response, :id, :name, :alias, :year

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = data.dig('league', 'id')
            @name     = data.dig('league', 'name')
            @alias    = data.dig('league', 'alias')

            @year     = data.dig('season', 'year')
            @type     = data.dig('season', 'type')

            @games_hash = {}
            @tournaments_hash = {}
            update_games(data['games'])             if data['games']
            update_tournaments(data['tournaments']) if data['tournaments']
          end

          def games
            @games_hash.values
          end

          def tournaments
            @tournaments_hash.values
          end

          def tournament(id)
            @tournaments_hash[id]
          end

          def update_games(data)
            create_data(@games_hash, data, klass: Game, api: @api, season: self)
          end

          def update_tournaments(data)
            create_data(@tournaments_hash, data, klass: Tournament, api: @api, season: self)
          end

        end
      end
    end
  end
end

__END__

sr = Sportradar::Api::Basketball::Ncaamb.new
sd = sr.daily_schedule;
ss = sr.schedule;
