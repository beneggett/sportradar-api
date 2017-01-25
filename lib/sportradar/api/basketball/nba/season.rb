module Sportradar
  module Api
    module Basketball
      class Nba
        class Season < Basketball::Season
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = response['id']
            @name     = response['name']
            @alias    = response['alias']
            @games_hash = {}

            update_games(data.dig('season_schedule', 'games', 'game'))
          end

          def games
            @games_hash.values
          end

          def year
            2016
          end

          def update_games(data)
            create_data(@games_hash, data, klass: Game, api: @api, season: self)
          end

        end
      end
    end
  end
end

__END__

sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
ss = sr.schedule;
