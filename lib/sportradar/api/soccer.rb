module Sportradar
  module Api
    class Soccer
      attr_accessor :league, :access_level
      def initialize(league = 'na', access_level = 't')
        @league = league
        @access_level = access_level
      end

      def schedule
        results = Sportradar::Api::Request.new.get(request_url("matches/schedule"), api_key )
      end

      def daily_schedule(date = Date.today)
        results = Sportradar::Api::Request.new.get(request_url("matches/#{date.year}/#{date.month}/#{date.day}/schedule"), api_key )
      end

      def daily_summary(date = Date.today)
        results = Sportradar::Api::Request.new.get(request_url("matches/#{date.year}/#{date.month}/#{date.day}/summary"), api_key )
      end

      def daily_boxscore(date = Date.today)
        results = Sportradar::Api::Request.new.get(request_url("matches/#{date.year}/#{date.month}/#{date.day}/boxscore"), api_key )
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_summary(match_id)
        results = Sportradar::Api::Request.new.get(request_url("matches/#{match_id}/summary"), api_key )
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_boxscore(match_id)
        results = Sportradar::Api::Request.new.get(request_url("matches/#{match_id}/boxscore"), api_key )
      end

      def team_hierarchy
        results = Sportradar::Api::Request.new.get(request_url("teams/hierarchy"), api_key )
      end

      # team_id = "b78b9f61-0697-4347-a1b6-b7685a130eb1"
      def team_profile(team_id)
        results = Sportradar::Api::Request.new.get(request_url("teams/#{team_id}/profile"), api_key )
      end

      def team_standings
        results = Sportradar::Api::Request.new.get(request_url("teams/standing"), api_key )
      end

      # player_id = "2aeacd39-3f9c-42af-957e-9df8573973c4"
      def player_profile(player_id)
        results = Sportradar::Api::Request.new.get(request_url("players/#{player_id}/profile"), api_key )
      end

      def player_rankings
        results = Sportradar::Api::Request.new.get(request_url("players/leader"), api_key )
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
    end
  end
end
