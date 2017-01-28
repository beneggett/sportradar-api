module Sportradar
  module Api
    module Basketball
      class Ncaamb < Request
        attr_accessor :league, :access_level, :simulation, :error

        def initialize(access_level = default_access_level)
          @league = 'ncaamb'
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
          @access_level = access_level
        end

        def schedule(season_year = default_year, ncaa_season = default_season)
          raise Sportradar::Api::Error::InvalidSeason unless allowed_seasons.include? ncaa_season
          response = get request_url("games/#{season_year}/#{ncaa_season}/schedule")
          if response.success?
            Sportradar::Api::Basketball::Ncaamb::Season.new(response.to_h, api: self)
          else
            @error = response
          end
        end

        def daily_schedule(date = default_date, ncaa_season = default_season)
          response = get request_url("games/#{ date.year }/#{ date.month }/#{ date.day }/schedule")
          if response.success?
            Sportradar::Api::Basketball::Ncaamb::Schedule.new(response.to_h, api: self)
          else
            @error = response
          end
        end

        def hierarchy
          response = get request_url("league/hierarchy")
          if response.success?
            Sportradar::Api::Basketball::Ncaamb::Hierarchy.new(response.to_h, api: self)
          else
            response
          end
        end

        def standings(season_year = default_year, ncaa_season = default_season)
          response = get request_url("seasontd/#{season_year}/#{ncaa_season}/standings")
          if response.success?
            Sportradar::Api::Basketball::Ncaamb::Division.new(response.to_h, api: self)
          else
            response
          end
        end

        def get_data(url)
          get request_url(url)
        end

        def default_year
          2016
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

        def check_simulation(game_id)
          @simulation = true if simulation_games.include?(game_id)
        end

        def request_url(path)
          # puts "/ncaamb-#{access_level}#{version}/#{path}"
          if simulation
            # "/nfl-sim1/#{path}"
          else
            "/ncaamb-#{access_level}#{version}/#{path}"
          end
        end

        def api_key
          if access_level != 't'
            Sportradar::Api.api_key_params('ncaamb', 'production')
          else
            Sportradar::Api.api_key_params('ncaamb')
          end
        end

        def version
          Sportradar::Api.version('nba')
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

sr = Sportradar::Api::Basketball::Ncaamb.new
ss = sr.schedule;
ds = sr.daily_schedule;

# not ready
lh = sr.league_hierarchy;
ls = sr.standings;