module Sportradar
  module Api
    module Mma
      class Api < Request
        attr_accessor :league_group, :access_level, :language_code, :error

        def initialize(access_level: default_access_level, language_code: 'en', **args)
          @league_group = league_group
          @language_code = language_code
          @access_level = access_level
          # raise Sportradar::Api::Error::InvalidLeague unless allowed_leagues.include? @league_group
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? @access_level
        end

        def default_year
          Date.today.year
        end
        # def default_season
        #   'reg'
        # end
        def default_access_level
          if (ENV['SPORTRADAR_ENV_MMA'] || ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
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
          "/mma/#{access_level}/v#{version}/#{language_code}/#{path}"
        end

        def api_key
          if !['trial', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'production')
            Sportradar::Api.api_key_params("mma", 'production')
          else
            Sportradar::Api.api_key_params("mma")
          end
        end

        def version
          Sportradar::Api.version('mma')
        end

        def allowed_access_levels
          %w[production trial]
        end

      end

    end
  end
end
