module Sportradar
  module Api
    module Football
      class Nfl
        class Api < Request
          attr_accessor :league, :access_level, :error

          def initialize(access_level = default_access_level)
            @league = 'nfl'
            raise ::Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
            @access_level = access_level
          end

          def default_year
            default_date.year
          end
          def default_date
            Date.today - 90
          end
          def default_season
            'reg'
          end
          def default_access_level
            if (ENV['SPORTRADAR_ENV'] || ENV['SPORTRADAR_ENV_NFL'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
              'o'
            else
              'ot'
            end
          end

          private

          def content_format
            'json'
          end

          def request_url(path)
            "/nfl-#{access_level}#{version}/#{path}"
          end

          def api_key
            if !['ot', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'o')
              ::Sportradar::Api.api_key_params('nfl', 'production')
            else
              ::Sportradar::Api.api_key_params('nfl')
            end
          end

          def version
            ::Sportradar::Api.version('nfl')
          end

          def allowed_access_levels
            %w[rt o p s b t ot sim]
          end

          def allowed_seasons
            ["pre", "reg", "pst"]
          end
        end

      end
    end
  end
end

__END__

nfl = Sportradar::Api::Football.Nfl.new
sw = nfl.weekly_schedule;
ss = nfl.schedule;

ss.games.count
ss.weeks.count
ss.weeks.first.response['game'].count

