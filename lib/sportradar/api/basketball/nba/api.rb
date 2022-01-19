module Sportradar
  module Api
    module Basketball
      class Nba
        class Api < Request
          attr_accessor :league, :access_level, :error

          def initialize(access_level = default_access_level)
            @league = 'nba'
            raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
            @access_level = access_level
          end

          def default_year
            (Date.today - 210).year
          end
          def default_date
            Date.today
          end
          def default_season
            'reg'
          end
          def default_access_level
            if (ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
              'production'
            else
              'trial'
            end
          end

          def content_format
            'json'
          end

          private

          def request_url(path)
            "/nba/#{access_level}/v#{version}/en/#{path}"
          end

          def api_key
            if !['trial', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'production')
              Sportradar::Api.api_key_params('nba', 'production')
            else
              Sportradar::Api.api_key_params('nba')
            end
          end

          def version
            Sportradar::Api.version('nba')
          end

          def allowed_access_levels
            %w[production trial sim]
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

sr = Sportradar::Api::Basketball::Nba.new
lh = sr.league_hierarchy;
ls = sr.standings;
