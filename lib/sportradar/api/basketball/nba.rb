module Sportradar
  module Api
    module Basketball
      class Nba < Request
        attr_accessor :league, :access_level, :simulation, :error

        def initialize(access_level = 'p')
          @league = 'nba'
          raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
          @access_level = access_level
        end

        def schedule(season_year = default_year, nba_season = default_season)
          raise Sportradar::Api::Error::InvalidSeason unless allowed_seasons.include? nba_season
          response = get request_url("games/#{season_year}/#{nba_season}/schedule")
          if response.success? && response['league']
            Sportradar::Api::Basketball::Nba::Season.new(response['league'], api: self)
          else
            @error = response
          end
        end

        def daily_schedule(date = default_date, nba_season = default_season)
          response = get request_url("games/#{ date.year }/#{ date.month }/#{ date.day }/schedule")
          if response.success? && response['league']
            Sportradar::Api::Basketball::Nba::Schedule.new(response['league'], api: self)
          else
            @error = response
          end
        end

        def league_hierarchy
          response = get request_url("league/hierarchy")
          if response.success? && response["league"]
            Sportradar::Api::Basketball::Nba::Hierarchy.new(response["league"], api: self)
          else
            response
          end
        end

        def team_stats(season_year = default_year, nba_season = default_season, team_id)
          response = get request_url("seasontd/#{season_year}/#{nba_season}/teams/#{team_id}/statistics")
          if response.success? && response["season"]
            # Sportradar::Api::Basketball::Nba::Team.new response["season"]
            response
          else
            response
          end
        end

        def standings(season_year = default_year, nba_season = default_season)
          response = get request_url("seasontd/#{season_year}/#{nba_season}/standings")
          if response.success? && response["league"]
            Sportradar::Api::Basketball::Nba::Hierarchy.new(response['league']["season"], api: self)
          else
            response
          end
        end

        def get_data(url)
          get request_url(url)
        end

        def get_pbp(*args)
          'pbp'
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

        private

        def check_simulation(game_id)
          @simulation = true if simulation_games.include?(game_id)
        end

        def request_url(path)
          puts "/nba-#{access_level}#{version}/#{path}"
          if simulation
            # "/nfl-sim1/#{path}"
          else
            "/nba-#{access_level}#{version}/#{path}"
          end
        end

        def api_key
          if access_level != 't'
            Sportradar::Api.api_key_params('nba', 'production')
          else
            Sportradar::Api.api_key_params('nba')
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

sr = Sportradar::Api::Basketball::Nba.new
lh = sr.league_hierarchy;
ls = sr.standings;