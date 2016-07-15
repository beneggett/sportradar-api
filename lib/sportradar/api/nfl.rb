module Sportradar
  module Api
    class Nfl < Request
      attr_accessor :league, :access_level
      def initialize( access_level = 'ot')
        @league = 'nfl'
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def league_hierarchy
        get request_url("league/hierarchy")
      end

      def schedule(year = Date.today.year, season = 'reg')
        raise Sportradar::Api::Error::InvalidSeason unless allowed_seasons.include? season
        get request_url("games/#{ year }/#{ season }/schedule")
      end

      def weekly_schedule(year = Date.today.year, season = 'reg', week = 1)
        get request_url("games/#{ week_path(year, season, week) }/schedule")
      end

      def standings(year = Date.today.year)
        get request_url("seasontd/#{ year }/standings")
      end

      def weekly_depth_charts(year = Date.today.year, season = 'reg', week = 1)
        get request_url("seasontd/#{ week_path(year, season, week) }/depth_charts")
      end

      def weekly_injuries(year = Date.today.year, season = 'reg', week = 1)
        get request_url("seasontd/#{ week_path(year, season, week) }/injuries")
      end

      def daily_change_log(date = Date.today)
        get request_url("league/#{date_path(date)}/changes")
      end

      # past_game_id = "0141a0a5-13e5-4b28-b19f-0c3923aaef6e"
      # future_game_id = "28290722-4ceb-4a4c-a4e5-1f9bec7283b3"
      def game_boxscore(game_id)
        get request_url("games/#{ game_id }/boxscore")
      end

      def game_roster(game_id)
        get request_url("games/#{ game_id }/roster")
      end

      def game_statistics(game_id)
        get request_url("games/#{ game_id }/statistics")
      end

      def play_by_play(game_id)
        get request_url("games/#{ game_id }/pbp")
      end

      # player_id = "ede260be-5ae6-4a06-887b-e4a130932705"
      def player_profile(player_id)
        get request_url("players/#{ player_id }/profile")
      end

      # team_id = "97354895-8c77-4fd4-a860-32e62ea7382a"
      def seasonal_statistics(team_id, year = Date.today.year, season = 'reg')
         raise Sportradar::Api::Error::InvalidLeague unless allowed_seasons.include? season
        get request_url("seasontd/#{ year }/#{ season }/teams/#{ team_id }/statistics")
      end

      def team_profile(team_id)
        get request_url("teams/#{ team_id }/profile")
      end

      private

      def request_url(path)
        "/nfl-#{access_level}#{version}/#{path}"
      end

      def api_key
        Sportradar::Api.api_key_params("nfl")
      end

      def version
        Sportradar::Api.version('nfl')
      end

      def allowed_access_levels
        ['o', 'ot']
      end

      def allowed_seasons
        ['pre', 'reg', 'pst']
      end
    end
  end
end
