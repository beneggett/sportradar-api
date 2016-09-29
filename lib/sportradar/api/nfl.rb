module Sportradar
  module Api
    class Nfl < Request
      attr_accessor :league, :access_level, :simulation

      def initialize( access_level = "ot")
        @league = "nfl"
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def schedule(year = Date.today.year, season = "reg")
        raise Sportradar::Api::Error::InvalidSeason unless allowed_seasons.include? season
        response = get request_url("games/#{ year }/#{ season }/schedule")
        if response.success? && response["season"]
          Sportradar::Api::Nfl::Season.new response["season"]
        else
          response
        end
      end

      def weekly_schedule(week = 1, year = Date.today.year, season = "reg")
        response = get request_url("games/#{ week_path(year, season, week) }/schedule")
        if response.success? && response["season"]
          Sportradar::Api::Nfl::Season.new response["season"]
        else
          response
        end
      end

      def weekly_depth_charts(week = 1, year = Date.today.year, season = "reg" )
        response = get request_url("seasontd/#{ week_path(year, season, week) }/depth_charts")
        if response.success?
          Sportradar::Api::Nfl::LeagueDepthChart.new response
        else
          response
        end
      end

      def weekly_injuries(week = 1, year = Date.today.year, season = "reg")
        response = get request_url("seasontd/#{ week_path(year, season, week) }/injuries")
        Sportradar::Api::Nfl::Season.new response["season"]  if response.success? && response["season"]
      end

      # past_game_id = "0141a0a5-13e5-4b28-b19f-0c3923aaef6e"
      # future_game_id = "28290722-4ceb-4a4c-a4e5-1f9bec7283b3"
      def game_boxscore(game_id)
        check_simulation(game_id)
        response = get request_url("games/#{ game_id }/boxscore")
        if response.success? && response["game"] # mostly done, just missing play statistics
          Sportradar::Api::Nfl::Game.new response["game"]
        else
          response
        end
      end

      def game_roster(game_id)
        check_simulation(game_id)
        response = get request_url("games/#{ game_id }/roster")
        if response.success? && response["game"]
          Sportradar::Api::Nfl::Game.new response["game"]
        else
          response
        end
      end

      def game_statistics(game_id)
        check_simulation(game_id)
        response = get request_url("games/#{ game_id }/statistics")
        if response.success? && response["game"]
          Sportradar::Api::Nfl::Game.new response["game"]
        else
          response
        end
        ## Need to properly implement statistics
      end

      def play_by_play(game_id)
        check_simulation(game_id)
        response = get request_url("games/#{ game_id }/pbp")
        if response.success? && response["game"]
          Sportradar::Api::Nfl::Game.new response["game"]
        else
          response
        end
        # need to get into quarters, drives, plays, stats more still
      end

      # player_id = "ede260be-5ae6-4a06-887b-e4a130932705"
      def player_profile(player_id)
        response = get request_url("players/#{ player_id }/profile")
        if response.success? && response["player"]
          Sportradar::Api::Nfl::Player.new response["player"]
        else
          response
        end
      end

      # team_id = "97354895-8c77-4fd4-a860-32e62ea7382a"
      def seasonal_statistics(team_id, year = Date.today.year, season = "reg")
         raise Sportradar::Api::Error::InvalidLeague unless allowed_seasons.include? season
        response = get request_url("seasontd/#{ year }/#{ season }/teams/#{ team_id }/statistics")
        if response.success? && response["season"]
          Sportradar::Api::Nfl::Season.new response["season"]
        else
          response
        end
        # TODO: Object map team & player records - statistics
      end

      def team_profile(team_id)
        response = get request_url("teams/#{ team_id }/profile")
        if response.success? && response["team"]
          Sportradar::Api::Nfl::Team.new response["team"]
        else
          response
        end
      end

      def league_hierarchy
        response = get request_url("league/hierarchy")
        if response.success? && response["league"]
          Sportradar::Api::Nfl::Hierarchy.new response["league"]
        else
          response
        end
      end

      def standings(year = Date.today.year)
        response = get request_url("seasontd/#{ year }/standings")
        if response.success? && response["season"]
          Sportradar::Api::Nfl::Season.new  response["season"]
        else
          response
        end
        # TODO Needs implement rankings/records/stats on team
      end

      def daily_change_log(date = Date.today)
        response = get request_url("league/#{date_path(date)}/changes")
       if response.success? && response["league"] && response["league"]["changelog"]
         Sportradar::Api::Nfl::Changelog.new response["league"]["changelog"]
        else
          response
        end
      end

      def simulation_games
        [
          "f45b4a31-b009-4039-8394-42efbc6d5532",
          "5a7042cb-fe7a-4838-b93f-6b8c167ec384",
          "7f761bb5-7963-43ea-a01b-baf4f5d50fe3"
        ]
      end

      def active_simulation
        game = simulation_games.lazy.map {|game_id| game_boxscore game_id }.find{ |g| g.status == 'inprogress' if g.is_a?(Sportradar::Api::Nfl::Game) }
        if game
          puts "Live Game: #{game.summary.home.full_name} vs #{game.summary.away.full_name}. Q#{game.quarter} #{game.clock}.  game_id='#{game.id}'"
          game
        else
          "No active simulation"
        end
      end

      private

      def check_simulation(game_id)
        @simulation = true if simulation_games.include?(game_id)
      end

      def request_url(path)
        if simulation
          "/nfl-sim1/#{path}"
        else
          "/nfl-#{access_level}#{version}/#{path}"
        end
      end

      def api_key
        if access_level == 'o'
          Sportradar::Api.api_key_params("nfl", "production")
        else
          Sportradar::Api.api_key_params("nfl")
        end
      end

      def version
        Sportradar::Api.version("nfl")
      end

      def allowed_access_levels
        ["o", "ot"]
      end

      def allowed_seasons
        ["pre", "reg", "pst"]
      end
    end
  end
end
