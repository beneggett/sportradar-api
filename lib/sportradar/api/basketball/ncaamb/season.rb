module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Season < Basketball::Season
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = data.dig('league', 'id')
            @name     = data.dig('league', 'name')
            @alias    = data.dig('league', 'alias')

            @games_hash = {}
            update_games(data['games'])
          end

          def games
            @games_hash.values
          end

          def year
            2016 # what is this doing here?
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

sr = Sportradar::Api::Basketball::Ncaamb.new
sd = sr.daily_schedule;
ss = sr.schedule;
