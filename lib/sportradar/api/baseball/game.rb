module Sportradar
  module Api
    module Baseball
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance, :team_stats, :player_stats, :changes

        attr_reader :inning, :half, :outs, :bases
        attr_reader :outcome, :count

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          # @season   = opts[:season]
          @updates  = {}
          @changes  = {}

          @score          = {}
          @team_stats     = {}
          @player_stats   = {}
          @scoring_raw    = Scoring.new(data, game: self)
          @teams_hash     = {}
          @innings_hash   = {}
          @home_runs      = nil
          @away_runs      = nil
          @home_id        = nil
          @away_id        = nil
          @outcome        = Outcome.new(data, game: self)
          @count          = {}

          @id = data['id']

          update(data, **opts)
        end

        def timeouts
          {}
        end

        def tied?
          @score[away_id].to_i == @score[home_id].to_i
        end
        def runs(team_id)
          summary_stat(team_id, 'runs')
        end
        def hits(team_id)
          summary_stat(team_id, 'hits')
        end
        def errors(team_id)
          summary_stat(team_id, 'errors')
        end
        def team_summary(team_id)
          team_id.is_a?(Symbol) ? @score[@team_ids[team_id]] : @score[team_id]
        end
        def summary_stat(team_id, stat)
          team_summary(team_id)[stat]
        end
        def stats(team_id)
          team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]].to_i : @team_stats[team_id].to_i
        end

        def scoring
          @scoring_raw.scores
        end
        def update_score(score)
          @score.merge!(score)
        end
        def update_stats(team, stats)
          @team_stats.merge!(team.id => stats.merge!(team: team))
        end
        def update_player_stats(player, stats)
          @player_stats.merge!(player.id => stats.merge!(player: player))
        end

        def parse_score(data)
          # home = { 'runs' => data.dig('home', 'runs'), 'hits' => data.dig('home', 'hits'), 'errors' => data.dig('home', 'errors') }
          # away = { 'runs' => data.dig('away', 'runs'), 'hits' => data.dig('away', 'hits'), 'errors' => data.dig('away', 'errors') }
          home_id = data.dig('home', 'id')
          away_id = data.dig('away', 'id')
          rhe = {
            'runs'    => { home_id => data.dig('home', 'runs'), away_id => data.dig('away', 'runs')},
            'hits'    => { home_id => data.dig('home', 'hits'), away_id => data.dig('away', 'hits')},
            'errors'  => { home_id => data.dig('home', 'errors'), away_id => data.dig('away', 'errors')},
          }
          @scoring_raw.update(rhe, source: :rhe)
          update_score(home_id => data.dig('home', 'runs'))
          update_score(away_id => data.dig('away', 'runs'))
        end

        def update(data, source: nil, **opts)
          # via pbp
          @title        = data['title']                 if data['title']
          @status       = data['status']                if data['status']
          @coverage     = data['coverage']              if data['coverage']
          @day_night    = data['day_night']             if data['day_night']
          @game_number  = data['game_number']           if data['game_number']
          @home_id      = data['home_team'] || data.dig('home', 'id')   if data['home_team'] || data.dig('home', 'id')
          @away_id      = data['away_team'] || data.dig('away', 'id')   if data['away_team'] || data.dig('away', 'id')
          # @home_runs    = data['home_runs'].to_i      if data['home_runs']
          # @away_runs    = data['away_runs'].to_i      if data['away_runs']

          @scheduled    = Time.parse(data["scheduled"]) if data["scheduled"]
          @venue        = Venue.new(data['venue']) if data['venue']
          @broadcast    = Broadcast.new(data['broadcast']) if data['broadcast']
          @home         = Team.new(data['home'], api: api, game: self) if data['home']
          @away         = Team.new(data['away'], api: api, game: self) if data['away']

          @duration     = data['duration']              if data['duration']
          @attendance   = data['attendance']            if data['attendance']

          # @lead_changes = data['lead_changes']          if data['lead_changes']
          # @times_tied   = data['times_tied']            if data['times_tied']

          @team_ids     = { home: @home_id, away: @away_id}

          # update_score(@home_id => @home_runs.to_i) if @home_runs
          # update_score(@away_id => @away_runs.to_i) if @away_runs
          if data['scoring']
            parse_score(data['scoring'])
          elsif data.dig('home', 'hits')
            parse_score(data)
          end
          @scoring_raw.update(data, source: source)
          if data['outcome']
            @outcome.update(data, source: nil)
            @count.merge!(@outcome.count)
          end

          create_data(@teams_hash, data['team'], klass: Team, api: api, game: self) if data['team']
        end

        # def update_from_team(id, data)
        # end

        def extract_count(data) # extract from pbp
          last_pitch = pitches.last
          return unless last_pitch
          @count.merge!(last_pitch.count)
          hi = last_pitch.at_bat.event.half_inning
          @count.merge!('inning' => hi.number.to_i, 'inning_half' => hi.half)
        end

        def home
          @teams_hash[@home_id] || @home
        end

        def away
          @teams_hash[@away_id] || @away
        end

        def leading_team_id
          return nil if score.values.uniq.size == 1
          score.max_by(&:last).first
        end

        def leading_team
          @teams_hash[leading_team_id] || (@away_id == leading_team_id && away) || (@home_id == leading_team_id && home)
        end

        def team(team_id)
          @teams_hash[team_id]
        end

        def assign_home(team)
          @home_id = team.id
          @teams_hash[team.id] = team
        end

        def assign_away(team)
          @away_id = team.id
          @teams_hash[team.id] = team
        end

        def box
          @box ||= get_box
        end

        def pbp
          if !future? && innings.empty?
            get_pbp
          end
          @pbp ||= innings
        end

        def atbats
          innings.flat_map(&:atbats)
        end

        def events
          innings.flat_map(&:events)
        end

        def at_bats
          events.map(&:at_bat).compact
        end

        def pitches
          at_bats.flat_map(&:pitches)
        end

        def summary
          @summary ||= get_summary
        end

        def innings
          @innings_hash.values
        end
        def half_innings
          innings.flat_map(&:half_innings)
        end

        # tracking updates
        def remember(key, object)
          @updates[key] = object&.dup
        end

        def not_updated?(key, object)
          @updates[key] == object
        end

        def changed?(key)
          @changes[key]
        end

        def check_newness(key, new_object)
          @changes[key] = !not_updated?(key, new_object)
          remember(key, new_object)
        end

        # status helpers
        def postponed?
          'postponed' == status
        end

        def unnecessary?
          'unnecessary' == status
        end

        def cancelled?
          ['unnecessary', 'postponed'].include? status
        end

        def future?
          ['scheduled', 'delayed', 'created', 'time-tbd'].include? status
        end

        def started?
          ['inprogress', 'halftime', 'delayed'].include? status
        end

        def finished?
          ['complete', 'closed'].include? status
        end

        def completed?
          'complete' == status
        end

        def closed?
          'closed' == status
        end

        # url path helpers
        def path_base
          "games/#{ id }"
        end

        def path_box
          "#{ path_base }/boxscore"
        end

        def path_pbp
          "#{ path_base }/pbp"
        end

        def path_summary
          "#{ path_base }/summary"
        end

        # data retrieval

        def get_box
          data = api.get_data(path_box)
          ingest_box(data)
        end

        def ingest_box(data)
          data = data['game']
          update(data, source: :box)
          check_newness(:box, @clock)
          data
        end

        def queue_pbp
          url, headers, options, timeout = api.get_request_info(path_pbp)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_pbp)}
        end

        def get_pbp
          data = api.get_data(path_pbp);
          ingest_pbp(data)
        end

        def ingest_pbp(data)
          data = data['game']
          update(data, source: :pbp)
          # @pbp = @innings_hash.values
          innings = data['innings'].each { |inning| inning['id'] = "#{data['id']}-#{inning['number']}" }
          create_data(@innings_hash, innings, klass: Inning, api: api, game: self) if data['innings']
          extract_count(data)
          # check_newness(:pbp, pitches.last)
          # check_newness(:score, @score)
          data
        # rescue => e
        #   binding.pry
        end

        def get_summary
          data = api.get_data(path_summary)
          ingest_summary(data)
        end

        def queue_summary
          url, headers, options, timeout = api.get_request_info(path_summary)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_summary)}
        end

        def ingest_summary(data)
          data = data['game']
          update(data, source: :summary)
          @inning = data.delete('inning').to_i
          check_newness(:box, @clock)
          check_newness(:score, @score)
          data
        end

        def set_pbp(data)
          create_data(@innings_hash, data, klass: inning_class, api: api, game: self)
          @innings_hash
        end

        def api
          @api || Sportradar::Api::Baseball::Mlb.new
        end
      end
    end
  end
end

__END__

# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
# res = mlb.get_schedule;
# g = mlb.games.first
# g = Sportradar::Api::Baseball::Game.new('id' => "8cd71519-429f-4461-88a2-8a0e134eb89b")
g = Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184")
res = g.get_pbp
res = g.get_summary;
res = g.get_box # probably not as useful as summary


mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_daily_summary;
g = mlb.games[8];
g.count
g.get_pbp;
g.count

