module Sportradar
  module Api
    module Baseball
      class Mlb < Request
        attr_accessor :league, :access_level, :simulation, :error

        def initialize(access_level = default_access_level)
          @league = 'mlb'
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
          @access_level = access_level
        end

        def get_data(url)
          data = get request_url(url)
          if data.is_a?(Sportradar::Api::Error)
            puts request_url(url)
            puts
            puts data.inspect
            raise 'Sportradar error'
          end
          data
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
          if (ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
            'p'
          else
            't'
          end
        end

        def content_format
          'json'
        end

        private

        def request_url(path)
          "/mlb-#{access_level}#{version}/#{path}"
        end

        def api_key
          if access_level != 't'
            Sportradar::Api.api_key_params('mlb', 'production')
          else
            Sportradar::Api.api_key_params('mlb')
          end
        end

        def version
          Sportradar::Api.version('mlb')
        end

        def allowed_access_levels
          %w[p t]
        end

        def allowed_seasons
          ["pre", "reg", "pst"]
        end

      end
    end
  end
end

__END__
