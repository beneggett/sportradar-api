module Sportradar
  module Api
    class Mma < Request
      attr_accessor :league, :access_level, :simulation, :error

      def initialize(access_level = 't')
        @league = 'mma'
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def schedule
        response = get request_url("schedule")
        if response.success? && response['schedule']
          Sportradar::Api::Mma::Schedule.new(response['schedule'], api: self)
        else
          @error = response
        end
      end

      def participants
        response = get request_url("profiles")
        if response.success? && response['profile']
          Sportradar::Api::Mma::Roster.new(response['profile'], api: self)
        else
          @error = response
        end
      end

      def statistics(event_id = "8f85ecc5-0d4d-470b-b357-075cc7e7bedd")
        event_hash = {"id" => event_id } # => UFC 205 - McGregor/Alvarez
        event = Event.new({ 'id' => event_id })
        event.get_stats
      end
      def generate_simulation_event(event_id = "8f85ecc5-0d4d-470b-b357-075cc7e7bedd")
        event = Event.new({ 'id' => event_id })
        i = 0
        base_path = "simulations/mma/#{event_id}"
        FileUtils.mkdir_p(base_path)
        loop do
          t = Time.now
          print "#{t}: Data pull #{i+=1}\r"
          res = event.get_stats.body
          File.write("#{base_path}/#{t.to_i}.xml", res)
          wait = (t.to_i + 60 - Time.now.to_i)
          wait.times do |j|
            print "#{t}: Data pull #{i} complete, #{wait - j} seconds until next.\r"
            sleep 1
          end
          puts
        end
      end

      # def roster(team_id, year = Date.today.year, season = "reg")
      #   Team.new(team_id).tap { |team| team.roster }
      # end


      # def weekly_depth_charts(week = 1, year = Date.today.year, season = "reg" )
      #   response = get request_url("seasontd/#{ week_path(year, season, week) }/depth_charts")
      #   Sportradar::Api::Nfl::LeagueDepthChart.new response
      # end

      # def weekly_injuries(week = 1, year = Date.today.year, season = "reg")
      #   response = get request_url("seasontd/#{ week_path(year, season, week) }/injuries")
      #   Sportradar::Api::Nfl::Season.new response["season"]  if response.success? && response["season"]
      # end

      # # gid = '8494fbf9-fe96-4d6d-81b2-5ed32347676f'
      # # past_game_id = "0141a0a5-13e5-4b28-b19f-0c3923aaef6e"
      # # future_game_id = "28290722-4ceb-4a4c-a4e5-1f9bec7283b3"
      # def game_boxscore(game_id)
      #   check_simulation(game_id)
      #   response = get request_url("games/#{ game_id }/boxscore")
      #   Sportradar::Api::Nfl::Game.new response["game"]   if response.success? && response["game"] # mostly done, just missing play statistics
      # end

      # def game_roster(game_id)
      #   check_simulation(game_id)
      #   response = get request_url("games/#{ game_id }/roster")
      #   Sportradar::Api::Nfl::Game.new response["game"]  if response.success? && response["game"]
      # end

      # def game_statistics(game_data)
      #   # check_simulation(game_id)
      #   base = "#{ year }/#{ mma_season }/#{ mma_season_week }/#{ away_team}/#{ home_team }/statistics"
      #   response = get_data(base)
      #   Sportradar::Api::Nfl::Game.new response["game"]  if response.success? && response["game"]
      #   ## Need to properly implement statistics
      # end

      # def play_by_play(game_id)
      #   check_simulation(game_id)
      #   response = get request_url("games/#{ game_id }/pbp")
      #   Sportradar::Api::Nfl::Game.new response["game"]  if response.success? && response["game"]
      #   # need to get into quarters, drives, plays, stats more still
      # end

      # # player_id = "ede260be-5ae6-4a06-887b-e4a130932705"
      # def player_profile(player_id)
      #   response = get request_url("players/#{ player_id }/profile")
      #   Sportradar::Api::Nfl::Player.new response["player"] if response.success? && response["player"]
      # end

      # # team_id = "97354895-8c77-4fd4-a860-32e62ea7382a"
      # def seasonal_statistics(team_id, year = Date.today.year, season = "reg")
      #    raise Sportradar::Api::Error::InvalidLeague unless allowed_seasons.include? season
      #   response = get request_url("seasontd/#{ year }/#{ season }/teams/#{ team_id }/statistics")
      #   Sportradar::Api::Nfl::Season.new response["season"]  if response.success? && response["season"]
      #   # TODO: Object map team & player records - statistics
      # end

      # def team_profile(team_id)
      #   response = get request_url("teams/#{ team_id }/profile")
      #   Sportradar::Api::Nfl::Team.new response["team"]  if response.success? && response["team"]
      # end

      # def league_hierarchy
      #   response = get request_url("league/hierarchy")
      #   Sportradar::Api::Nfl::Hierarchy.new response["league"]  if response.success? && response["league"]
      # end

      # def standings(year = Date.today.year)
      #   response = get request_url("seasontd/#{ year }/standings")
      #   Sportradar::Api::Nfl::Season.new  response["season"] if response.success? && response["season"]
      #   # TODO Needs implement rankings/records/stats on team
      # end

      # def daily_change_log(date = Date.today)
      #   response = get request_url("league/#{date_path(date)}/changes")
      #   Sportradar::Api::Nfl::Changelog.new response["league"]["changelog"] if response.success? && response["league"] && response["league"]["changelog"]
      # end

      # def simulation_games
      #   [
      #     # "f45b4a31-b009-4039-8394-42efbc6d5532",
      #     # "5a7042cb-fe7a-4838-b93f-6b8c167ec384",
      #     # "7f761bb5-7963-43ea-a01b-baf4f5d50fe3"
      #   ]
      # end

      # def active_simulation
      #   game = simulation_games.lazy.map {|game_id| game_boxscore game_id }.find{ |game| game.status == 'inprogress'}
      #   if game
      #     puts "Live Game: #{game.summary.home.full_name} vs #{game.summary.away.full_name}. Q#{game.quarter} #{game.clock}.  game_id='#{game.id}'"
      #     game
      #   else
      #     puts "No active simulation"
      #   end
      # end

      def get_data(url)
        get request_url(url)
      end

      private

      # def check_simulation(game_id)
      #   @simulation = true if simulation_games.include?(game_id)
      # end

      def request_url(path)
        "/mma-#{access_level}#{version}/#{path}"
      end

      def api_key
        if access_level != 't'
          Sportradar::Api.api_key_params('mma', 'production')
        else
          Sportradar::Api.api_key_params('mma')
        end
      end

      def version
        Sportradar::Api.version('mma')
      end

      def allowed_access_levels
        %w[p t]
      end

    end
  end
end

__END__

sr = Sportradar::Api::Mma.new
ss = sr.schedule;
sp = sr.participants;

ss.games.count
ss.weeks.count
ss.weeks.first.response['game'].count

