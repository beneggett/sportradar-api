module Sportradar
  module Api
    class Soccer < Request
      attr_accessor :league, :access_level, :simulation
      def initialize(league = "na", access_level = "t")
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        raise Sportradar::Api::Error::InvalidLeague unless allowed_leagues.include? league
        @league = league
        @access_level = access_level
      end

      def schedule
        response = get request_url("matches/schedule")
        if response.success?
          Sportradar::Api::Soccer::Schedule.new response
        else
          response
        end
      end

      # date =  Date.parse('2016-07-17')
      def daily_schedule(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/schedule")
        if response.success?
          Sportradar::Api::Soccer::Schedule.new response
        else
          response
        end
      end


      def daily_summary(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/summary")
        if response.success?
          Sportradar::Api::Soccer::Summary.new response
        else
          response
        end
      end

      def daily_boxscore(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/boxscore")
        if response.success?
          Sportradar::Api::Soccer::Boxscore.new response
        else
          response
        end
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_summary(match_id)
        check_simulation(match_id)
        response = get request_url("matches/#{match_id}/summary")
        if response.success?
          Sportradar::Api::Soccer::Summary.new response
        else
          response
        end
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_boxscore(match_id)
        check_simulation(match_id)
        response = get request_url("matches/#{match_id}/boxscore")
        if response.success?
          Sportradar::Api::Soccer::Boxscore.new response
        else
          response
        end
      end

      # team_id = "b78b9f61-0697-4347-a1b6-b7685a130eb1"
      def team_profile(team_id)
        response = get request_url("teams/#{team_id}/profile")
        if response.success? && response["profile"] && response["profile"]["team"]
          Sportradar::Api::Soccer::Team.new response["profile"]["team"]
        else
          response
        end
      end

      # player_id = "2aeacd39-3f9c-42af-957e-9df8573973c4"
      def player_profile(player_id)
        response = get request_url("players/#{player_id}/profile")
        if response.success? && response["profile"] && response["profile"]["player"]
          Sportradar::Api::Soccer::Player.new response["profile"]["player"]
        else
          response
        end
      end

      def player_rankings
        response = get request_url("players/leader")
        if response.success? && response["leaders"]
          Sportradar::Api::Soccer::Ranking.new response["leaders"]
        else
          response
        end
      end

      def team_hierarchy
        response = get request_url("teams/hierarchy")
        if response.success? && response["hierarchy"]
          Sportradar::Api::Soccer::Hierarchy.new response["hierarchy"]
        else
          response
        end
      end

      def team_standings
        response = get request_url("teams/standing")
        if response.success?
          Sportradar::Api::Soccer::Standing.new response["standings"]
        else
          response
        end
      end

      def simulation_match
        "22653ed5-0b2c-4e30-b10c-c6d51619b52b"
      end

      private

      def check_simulation(match_id)
        @simulation = true if match_id == simulation_match
      end

      def request_url(path)
        if simulation
          "/soccer-sim2/wc/#{path}"
        else
          "/soccer-#{access_level}#{version}/#{league}/#{path}"
        end
      end

      def api_key
        if access_level == 'p'
          Sportradar::Api.api_key_params("soccer_#{league}", "production")
        else
          Sportradar::Api.api_key_params("soccer_#{league}")
        end
      end

      def version
        Sportradar::Api.version("soccer")
      end

      def allowed_access_levels
        ["p", "t"]
      end

      def allowed_leagues
        ["eu", "na", "sa", "wc", "as", "af"]
      end
    end
  end
end
