module Sportradar
  module Api
    class Soccer < Request
      attr_accessor :league, :access_level
      def initialize(league = 'na', access_level = 't')
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        raise Sportradar::Api::Error::InvalidLeague unless allowed_leagues.include? league
        @league = league
        @access_level = access_level
      end

      def schedule
        get request_url("matches/schedule")
      end

      def daily_schedule(date = Date.today)
        get request_url("matches/#{date.year}/#{date.month}/#{date.day}/schedule")
      end

      def daily_summary(date = Date.today)
        get request_url("matches/#{date.year}/#{date.month}/#{date.day}/summary")
      end

      def daily_boxscore(date = Date.today)
        get request_url("matches/#{date.year}/#{date.month}/#{date.day}/boxscore")
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_summary(match_id)
        get request_url("matches/#{match_id}/summary")
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_boxscore(match_id)
        get request_url("matches/#{match_id}/boxscore")
      end

      def team_hierarchy
        get request_url("teams/hierarchy")
      end

      # team_id = "b78b9f61-0697-4347-a1b6-b7685a130eb1"
      def team_profile(team_id)
        get request_url("teams/#{team_id}/profile")
      end

      def team_standings
        get request_url("teams/standing")
      end

      # player_id = "2aeacd39-3f9c-42af-957e-9df8573973c4"
      def player_profile(player_id)
        get request_url("players/#{player_id}/profile")
      end

      def player_rankings
        get request_url("players/leader")
      end

      private

      def request_url(path)
        "/soccer-#{access_level}#{version}/#{league}/#{path}"
      end

      def api_key
        Sportradar::Api.api_key_params("soccer_#{league}")
      end

      def version
        Sportradar::Api.version('soccer')
      end

      def allowed_access_levels
        ['p', 't']
      end

      def allowed_leagues
        ['eu', 'na', 'sa', 'wc', 'as', 'af']
      end
    end
  end
end
