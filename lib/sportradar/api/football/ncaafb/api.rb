module Sportradar
  module Api
    module Football
      class Ncaafb
        class Api < Request
          attr_accessor :league, :access_level, :error

          def initialize(access_level = default_access_level)
            @league = 'ncaafb'
            raise ::Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
            @access_level = access_level
          end

          def sim!
            @access_level = "sim-#{default_access_level}"
            self
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
            if (ENV['SPORTRADAR_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV']) == 'production'
              ENV['SPORTRADAR_ACCESS_NCAAFB'] || 'rt'
            else
              't'
            end
          end

          private

          def content_format
            'json'
          end

          def request_url(path)
            "/ncaafb-#{access_level}#{version}/#{path}"
          end

          def api_key
            if !['t', 'sim-t'].include?(access_level)
              ::Sportradar::Api.api_key_params('ncaafb', 'production')
            else
              ::Sportradar::Api.api_key_params('ncaafb')
            end
          end

          def version
            ::Sportradar::Api.version('ncaafb')
          end

          def allowed_access_levels
            %w[rt p s b t sim-t]
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

ncaafb = Sportradar::Api::Ncaafb.new
sw = ncaafb.weekly_schedule;
ss = ncaafb.schedule;

ss.games.count
ss.weeks.count
ss.weeks.first.response['game'].count

