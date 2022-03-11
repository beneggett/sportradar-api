module Sportradar
  module Api
    module Baseball
      class Mlb
        class Api < Request
          attr_accessor :league, :access_level, :simulation, :error

          def initialize(access_level = default_access_level)
            @league = 'mlb'
            raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
            @access_level = access_level
          end

          def sim!
            @version = 5
            super
          end

          def default_year
            Date.today.year
          end
          def default_date
            Date.today
          end
          def default_season
            'reg'
          end
          def default_access_level
            if (ENV['SPORTRADAR_ENV_MLB'] || ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
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
            "/mlb/#{access_level}/v#{version}/en/#{path}"
          end

          def api_key
            if !['trial', 'sim'].include?(access_level)
              Sportradar::Api.api_key_params('mlb', 'production')
            elsif 'sim' == access_level
              Sportradar::Api.api_key_params('mlb', 'simulation')
            else
              Sportradar::Api.api_key_params('mlb')
            end
          end

          def version
            @version || Sportradar::Api.version('mlb')
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
# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
