module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Api < Request
          attr_accessor :league, :access_level, :error

          def initialize(access_level = default_access_level)
            @league = 'ncaamb'
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
            "/ncaamb-#{access_level}#{version}/#{path}"
          end

          def api_key
            if !['t', 'sim'].include?(access_level) || (access_level == 'sim' && default_access_level == 'p')
              Sportradar::Api.api_key_params('ncaamb', 'production')
            else
              Sportradar::Api.api_key_params('ncaamb')
            end
          end

          def version
            Sportradar::Api.version('ncaamb')
          end

          def allowed_access_levels
            %w[p t sim]
          end

          def allowed_seasons
            ["pre", "reg", 'ct', "pst"]
          end

        end
      end
    end
  end
end

__END__

sr = Sportradar::Api::Basketball::Ncaamb.new
ss = sr.schedule(2015, 'ct');
ss = sr.schedule(2015, 'pst');
rank = sr.rankings('US');
ds = sr.daily_schedule;

# not ready
lh = sr.league_hierarchy;
ls = sr.standings;