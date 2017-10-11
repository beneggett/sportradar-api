module Sportradar
  module Api
    module Baseball
      class Game < Data
        attr_accessor :response, :id, :title, :home_id, :away_id, :score, :status, :coverage, :scheduled, :venue, :broadcast, :duration, :attendance, :team_stats, :player_stats, :changes, :lineup

        attr_reader :inning, :half, :outs, :bases, :pitchers, :final, :rescheduled, :inning_over
        attr_reader :outcome, :count
        DEFAULT_BASES = { '1' => nil, '2' => nil, '3' => nil }

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
          @lineup         = Lineup.new(data, game: self)
          @teams_hash     = {}
          @innings_hash   = {}
          @home_runs      = nil
          @away_runs      = nil
          @home_id        = nil
          @away_id        = nil
          @outcome        = Outcome.new(data, game: self)
          @count          = {}
          @pitchers       = {}
          @bases          = { '1' => nil, '2' => nil, '3' => nil }

          @id = data['id']

          update(data, **opts)
        end
        def lineup
          @lineup ||= Lineup.new({}, game: self)
        end

        def timeouts
          {}
        end

        def tied?
          @score[away_id].to_i == @score[home_id].to_i
        end
        # def runs(team_id)
        #   summary_stat(team_id, 'runs')
        # end
        def hits(team_id)
          @scoring_raw.hits(team_id)
        end
        def errors(team_id)
          @scoring_raw.errors(team_id)
        end
        def runs(team_id)
          team_id.is_a?(Symbol) ? @score[@team_ids[team_id]] : @score[team_id]
        end
        def summary_stat(team_id, stat_name)
          scoring.dig(team_id, stat_name)
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

        def parse_pitchers(data)
          pitchers = {
            'starting'  => { home_id => data.dig('home', 'starting_pitcher'), away_id => data.dig('away', 'starting_pitcher')},
            'probable'  => { home_id => data.dig('home', 'probable_pitcher'), away_id => data.dig('away', 'probable_pitcher')},
            'current'   => { home_id => data.dig('home', 'current_pitcher'),  away_id => data.dig('away', 'current_pitcher')},
          }
          @pitchers.merge!(pitchers) do |key, current_val, merge_val|
            current_val.merge(merge_val) { |k, cur, mer| (mer || cur) }
          end
        end

        def update(data, source: nil, **opts)
          # via pbp
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
          @broadcast    = Broadcast.new(data['broadcast']) if !data['broadcast'].to_h.empty?
          @home         = Team.new(data['home'] || data.dig('scoring', 'home'), api: api, game: self) if data['home'] || data.dig('scoring', 'home')
          @away         = Team.new(data['away'] || data.dig('scoring', 'away'), api: api, game: self) if data['away'] || data.dig('scoring', 'away')
          @title        = data['title'] || @title || (home && away && "#{home.full_name} vs #{away.full_name}")

          @duration     = data['duration']              if data['duration']
          @attendance   = data['attendance']            if data['attendance']

          @final        = data['final']                 if data['final']
          @rescheduled  = data['rescheduled']           if data['rescheduled']

          @team_ids     = { home: @home_id, away: @away_id}

          update_bases(data)
          parse_pitchers(data) if data['home'] && data['away']

          lineup.update(data, source: source) unless source == :pbp
          if data['scoring']
            parse_score(data['scoring'])
          elsif data.dig('home', 'hits')
            parse_score(data)
          end
          @scoring_raw.update(data, source: source)
          if data['outcome']
            @outcome.update(data, source: nil)
            @count.merge!(@outcome.count || {})
          end
          create_data(@teams_hash, data['team'], klass: Team, api: api, game: self) if data['team']
        end

        # def update_from_team(id, data)
        # end

        def update_bases(data)
          if data.is_a?(Sportradar::Api::Baseball::Error)
            puts data.inspect
            return
          end
          @bases = if data.respond_to?(:runners)
            hash = Array(data.runners).map { |runner| [runner.ending_base.to_s, runner.id] if !runner.out }.compact.to_h
            DEFAULT_BASES.merge(hash)
          elsif (runners = data.dig('outcome', 'runners'))
            hash = runners.map { |runner| [runner['ending_base'].to_s, runner['id']] if !runner['out'] }.compact.to_h
            DEFAULT_BASES.merge(hash)
          else # probably new inning, no runners
            DEFAULT_BASES.dup
          end
        rescue => e
          puts data.inspect
          raise e
        end
        def advance_inning
          @inning_over = false
          return unless count['outs'] == 3
          if count['inning'] >= 9
            if count['inning_half'] == 'T' && leading_team_id == home.id
              return
            elsif count['inning_half'] == 'B' && !tied?
              return
            end
          end
          @inning_over = true
          @bases = DEFAULT_BASES.dup
          half, inn = if count['inning_half'] == 'B'
            ['E', count['inning']]
          elsif count['inning_half'] == 'T'
            ['M', count['inning']]
          else
            [nil, 1]
          end
          @count = {
            'balls'       => 0,
            'strikes'     => 0,
            'outs'        => 0,
            'inning'      => inn,
            'inning_half' => half,
          }
        end

        def extract_count(data) # extract from pbp
          recent_pitches = pitches.last(10)
          last_pitch = recent_pitches.reverse_each.detect(&:count)
          return unless last_pitch
          update_bases(last_pitch)
          @count.merge!(last_pitch.count)
          hi = last_pitch.at_bat.event.half_inning
          @count.merge!('inning' => hi.number.to_i, 'inning_half' => hi.half)
          advance_inning
        end

        def home
          @teams_hash[@home_id] || @home
        end

        def away
          @teams_hash[@away_id] || @away
        end

        def leading_team_id
          return nil if tied?
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

        def realtime_state(full_word: false)
          if future?
            'Scheduled'
          elsif delayed?
            'Delayed'
          elsif finished?
            'Final'
          elsif postponed?
            'Postponed'
          else
            full_word ? inning_word : inning_short
          end
        end

        def inning_abbr
          if !count.empty?
            inning_half = self.count['inning_half']
            inning = self.count['inning']
            "#{inning_half || 'T'}#{(inning || 1)}"
          end
        end

        def inning_short
          if !count.empty?
            inning_half = self.count['inning_half']
            inning = self.count['inning']
            "#{half_short} #{ordinalize_inning(inning || 1)}" # TODO remove AS dependency
          end
        end

        def inning_word
          if !count.empty?
            inning_half = self.count['inning_half']
            inning = self.count['inning']
            "#{half_word} #{ordinalize_inning(inning || 1)}"
          end
        end

        def ordinalize_inning(i)
          case i
          when 1
            '1st'
          when 2
            '2nd'
          when 3
            '3rd'
          when nil
            ''
          else
            "#{i}th"
          end
        end

        def half_word
          {
            'B' => 'Bottom',
            'T' => 'Top',
            'M' => 'Middle',
            'E' => 'End',
          }.freeze[self.count['inning_half']]
        end

        def half_short
          {
            'B' => 'Bot',
            'T' => 'Top',
            'M' => 'Mid',
            'E' => 'End',
          }.freeze[self.count['inning_half']]
        end

        def postponed?
          'postponed' == status
        end

        def unnecessary?
          'unnecessary' == status
        end

        def cancelled?
          ['unnecessary', 'postponed'].include? status
        end

        def delayed?
          ['wdelay', 'delayed'].include? status
        end

        def future?
          ['scheduled', 'delayed', 'created', 'time-tbd'].include? status
        end

        def started?
          ['inprogress', 'wdelay', 'delayed'].include? status
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
          innings = data['innings'].each { |inning| inning['id'] = "#{data['id']}-#{inning['number']}" }
          create_data(@innings_hash, innings, klass: Inning, api: api, game: self) if data['innings']
          extract_count(data)
          lineup.update(data, source: :pbp)
          # update lineups
          check_newness(:pitches, pitches.last&.id)
          check_newness(:events, events.last&.description)
          check_newness(:score, @score)
          @pbp = @innings_hash.values
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
          @api || Sportradar::Api::Baseball::Mlb::Api.new
        end

        def sim!
          @api = api.sim!
          self
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
g = Sportradar::Api::Baseball::Game.new('id' => "9d0fe41c-4e6b-4433-b376-2d09ed39d184");
g = Sportradar::Api::Baseball::Game.new('id' => "fe9f37fd-6848-4a32-a999-9655044b7319");
res = g.get_pbp;
res = g.get_summary;
res = g.get_box # probably not as useful as summary


mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_daily_summary;
g = mlb.games[8];
g.count
g.get_pbp;
g.count

# mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new;
# res = mlb.get_daily_summary;
# g = mlb.games.sort_by(&:scheduled).first;
g = Sportradar::Api::Baseball::Game.new('id' => "8731b56d-9037-44d1-b890-fa496e94dc10");
res = g.get_pbp;
res = g.get_summary;
g.pitchers

