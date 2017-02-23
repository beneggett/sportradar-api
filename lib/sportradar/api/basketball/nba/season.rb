module Sportradar
  module Api
    module Basketball
      class Nba
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

            update_games(data['games'])
          end

          def games
            @games_hash.values
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
ss = sr.standings;
ss = sr.schedule;
ss = sr.schedule(2015, 'pst)');
