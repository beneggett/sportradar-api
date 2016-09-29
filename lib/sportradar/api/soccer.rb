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
        process_response( response, klass: Sportradar::Api::Soccer::Schedule )
      end

      # date =  Date.parse('2016-07-17')
      def daily_schedule(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/schedule")
        process_response( response, klass: Sportradar::Api::Soccer::Schedule )
      end


      def daily_summary(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/summary")
        process_response( response, klass: Sportradar::Api::Soccer::Summary )
      end

      def daily_boxscore(date = Date.today)
        response = get request_url("matches/#{date_path(date)}/boxscore")
        process_response( response, klass: Sportradar::Api::Soccer::Boxscore )
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_summary(match_id)
        check_simulation(match_id)
        response = get request_url("matches/#{match_id}/summary")
        process_response( response, klass: Sportradar::Api::Soccer::Summary )
      end

      # match_id  = "357607e9-87cd-4848-b53e-0485d9c1a3bc"
      def match_boxscore(match_id)
        check_simulation(match_id)
        response = get request_url("matches/#{match_id}/boxscore")
        process_response( response, klass: Sportradar::Api::Soccer::Boxscore )
      end

      # team_id = "b78b9f61-0697-4347-a1b6-b7685a130eb1"
      def team_profile(team_id)
        response = get request_url("teams/#{team_id}/profile")

        process_response( response, klass: Sportradar::Api::Soccer::Team, klass_args: 'response["profile"]["team"]', conditional: response["profile"] && response["profile"]["team"] )
      end

      # player_id = "2aeacd39-3f9c-42af-957e-9df8573973c4"
      def player_profile(player_id)
        response = get request_url("players/#{player_id}/profile")
        process_response( response, klass: Sportradar::Api::Soccer::Player, klass_args: response["profile"]["player"], conditional: response["profile"] && response["profile"]["player"] )
      end

      def player_rankings
        response = get request_url("players/leader")
        process_response( response, klass: Sportradar::Api::Soccer::Ranking, klass_args: response["leaders"], conditional: response["leaders"] )
      end

      def team_hierarchy
        response = get request_url("teams/hierarchy")
        process_response( response, klass: Sportradar::Api::Soccer::Hierarchy, klass_args: response["hierarchy"], conditional: response["hierarchy"] )
      end

      def team_standings
        response = get request_url("teams/standing")
        process_response( response, klass: Sportradar::Api::Soccer::Standing, klass_args: response["standings"], conditional: response["standings"] )
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
