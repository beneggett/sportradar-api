module Sportradar
  module Api
    module Soccer
      class Api < Request
        attr_accessor :league_group, :access_level, :language_code, :error

        def initialize(access_level: default_access_level, league_group:, language_code: 'en')
          @league_group = league_group
          @language_code = language_code
          @access_level = access_level
          raise Sportradar::Api::Error::InvalidLeague unless allowed_leagues.include? @league_group
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? @access_level
        end

        def default_year
          (Date.today - 210).year # TODO
        end
        def default_season
          'reg'
        end
        def default_access_level
          if (ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
            'x'
          else
            'xt'
          end
        end

        def content_format
          'json'
        end

        private

        def request_url(path)
          "/soccer-#{access_level}#{version}/#{league_group}/#{language_code}/#{path}"
        end

        def api_key
          if !['xt', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'x')
            Sportradar::Api.api_key_params("soccer-#{@league_group}", 'production')
          else
            Sportradar::Api.api_key_params("soccer-#{@league_group}")
          end
        end

        def version
          Sportradar::Api.version('soccer')
        end

        def allowed_access_levels
          %w[x xt sim]
        end

        def allowed_leagues
          ["eu", "am", "as", "intl", "other", "global"]
        end

        # def allowed_seasons
        #   ["pre", "reg", "pst"]
        # end
      end

    end
  end
end
