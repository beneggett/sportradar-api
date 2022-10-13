module Sportradar
  module Api
    module Odds
      class Api < Request
        attr_accessor :access_level, :language_code, :error, :base_path

        def initialize(base_path:, access_level: default_access_level, language_code: 'en', **args)
          @language_code = language_code
          @access_level = access_level
          @base_path = base_path
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? @access_level
        end

        def default_season
          'reg'
        end

        def default_access_level
          if (ENV['SPORTRADAR_ODDS_ENV'] || ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
            'production'
          else
            'trial'
          end
        end

        def content_format
          'json'
        end

        def inspect
          self.class.name
        end

        private

        def request_url(path)
          "/#{base_path}/#{access_level}/v#{version}/#{language_code}/#{path}"
        end

        def api_key
          if !['trial', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'production')
            Sportradar::Api.api_key_params("odds", 'production')
          else
            Sportradar::Api.api_key_params("odds")
          end
        end

        def version
          Sportradar::Api.version('odds')
        end

        def allowed_access_levels
          %w[production trial]
        end

      end

    end
  end
end
