module Sportradar
  module Api
    module Soccer
      class Match < Data
        attr_reader :id, :league_group, :scheduled, :start_time_tbd, :status, :tournament_round, :match_status, :venue
        attr_reader :home_score, :away_score, :winner_id, :aggregate_home_score, :aggregate_away_score, :aggregate_winner_id
        attr_reader :referee, :weather_info, :coverage_info, :probabilities
        attr_reader :home, :away, :tournament_id
        attr_reader :period, :score, :broadcast, :coverage # these are for consistency with other sports
        attr_reader :match_time, :stoppage_time
        attr_reader :team_stats, :player_stats

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id']
          @api          = opts[:api]
          @updates      = {}
          @changes      = {}

          @league_group = league_group || data['league_group'] || @api&.league_group

          @timeline_hash = {}
          @lineups_hash  = {}
          get_tournament_id(data, **opts)
          @scoring_raw   = Scoring.new(data, game: self)
          @home          = Team.new({}, api: api, match: self)
          @away          = Team.new({}, api: api, match: self)
          @teams_hash    = { away: @away, home: @home }
          @team_ids      = { away: @away.id, home: @home.id }
          @team_stats    = {}
          @player_stats  = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @league_group = opts[:league_group] || data['league_group'] || @league_group
          get_tournament_id(data, **opts)
          if data["sport_event"]
            update(data["sport_event"])
          end
          if data["sport_event_status"]
            update(data["sport_event_status"])
          end
          if data['sport_event_conditions']
            update(data['sport_event_conditions'])
          end
          if data['probabilities']
            # update(data['probabilities'])
            @probabilities = data['probabilities'] # tidy this up later
          end
          if data['lineups']
            create_data(@lineups_hash, data['lineups'], klass: Lineup, identifier: 'team', api: api)
          end
          if (stats = data.dig('statistics', 'teams'))
            update_teams(stats)
          end

          @scheduled        = Time.parse(data['scheduled'])         if data['scheduled']
          @start_time_tbd   = data['start_time_tbd']                if data.key?('start_time_tbd')
          @status           = data['status']                        if data['status']
          @match_status     = data['match_status']                  if data['match_status']
          @tournament_round = data['tournament_round']              if data['tournament_round']
          @venue            = Venue.new(data['venue'])              if data['venue']
          @weather_info     = OpenStruct.new(data["weather_info"])  if data["weather_info"]
          @referee          = OpenStruct.new(data["referee"])       if data["referee"]
          @coverage_info    = OpenStruct.new(data["coverage_info"]) if data["coverage_info"]

          @home_score       = data['home_score']                    if data['home_score']
          @away_score       = data['away_score']                    if data['away_score']
          @period           = data['period']                        if data['period']
          @match_time       = data.dig('clock', 'match_time')       if data.dig('clock', 'match_time')
          @stoppage_time    = data.dig('clock', 'stoppage_time')    if data.dig('clock', 'stoppage_time')
          @ball_locations   = data['ball_locations']                if data['ball_locations']
          @winner_id        = data['winner_id']                     if data['winner_id']

          @aggregate_home_score = data['aggregate_home_score']      if data['aggregate_home_score']
          @aggregate_away_score = data['aggregate_away_score']      if data['aggregate_away_score']
          @aggregate_winner_id  = data['aggregate_winner_id']       if data['aggregate_winner_id']
          @scoring_raw.update(data, source: opts[:source])
          create_data(@timeline_hash, data['timeline'], klass: Event, api: api)

          if data['competitors']
            update_teams(data['competitors'])
          end

          # parse_nested_data(data)
        end

        def title
          [@home, @away].compact.map(&:name).join(' vs ')
        end
        def scoring
          @scoring_raw.scores.each { |period, hash| hash[@home.id] = hash['home']; hash[@away.id] = hash['away'] }
        end
        def score
          {@home.id => @home_score, @away.id => @away_score}
        end

        # status helpers
        def realtime_state_short
          if future?
            'Scheduled' # ??
          elsif finished?
            'FT'
          elsif postponed?
            'PPD'
          elsif halftime?
            'HT'
          else
            clock_display
          end
        end

        def realtime_state
          if future?
            'Scheduled'
          elsif finished?
            'Final'
          elsif postponed?
            'Postponed'
          elsif halftime?
            'Halftime'
          else
            clock_display
          end
        end

        def halftime?
          @match_status == "halftime"
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
        def future?
          ['not_started', 'scheduled', 'delayed', 'created', 'time-tbd', 'if-necessary'].include? status
        end
        def started?
          ['live'].include?(@status) || ['halftime', '1st_half', '2nd_half'].include?(@match_status)
        end
        def finished?
          ['complete', 'closed'].include?(@status) || ['ended'].include?(@match_status)
        end
        def completed?
          'complete' == status
        end
        def closed?
          'closed' == status
        end

        def clock_display
          return unless @match_time
          if @match_time == '45:00' || @match_time == '90:00' # stoppage time
            @match_time.split(':').first + ?'
          else
            @match_time.split(':').first + ?'
          end
        end
        alias :clock :clock_display

        def match_seconds
          return nil unless @match_time
          mm, ss = @match_time.split(':').map(&:to_i)
          time = mm * 60 + ss
          if @stoppage_time && (@match_time == '45:00' || @match_time == '90:00') # stoppage time
            mm, ss = @stoppage_time.split(':').map(&:to_i)
            stop_time = mm * 60 + ss
            time += stop_time
          end
          time
        end
        alias :game_seconds :match_seconds

        def update_teams(data)
          home_hash = data.detect { |team_hash| team_hash["qualifier"] == "home" || team_hash["team"] == "home" }
          away_hash = (data - [home_hash]).first
          if home_hash && away_hash
            @home.update(home_hash, match: self)
            @away.update(away_hash, match: self)
            @teams_hash[@home.id] = @home
            @teams_hash[@away.id] = @away
            @team_ids = { away: @away.id, home: @home.id }
          end
        end

        def update_stats(team, stats)
          @team_stats.merge!(team.id => stats.merge(team: team))
        end
        def update_player_stats(player, stats)
          @player_stats.merge!(player.id => stats.merge!(player: player))
        end
        def stats(team_id)
          team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]] : @team_stats[team_id]
        end

        def get_tournament_id(data, **opts)
          @tournament_id ||= if opts[:tournament]
            opts[:tournament].id
          elsif opts[:season]
            opts[:season].tournament_id
          elsif opts[:match]
            opts[:match].tournament_id
          elsif data['tournament']
            data.dig('tournament', 'id')
          elsif data['season']
            data.dig('season', 'tournament_id')
          end
        end

        def team(place_or_id)
          @teams_hash[place_or_id]
        end

        def timeline(type = nil)
          if type
            @timeline_hash.each_value.select { |ev| ev.type == type }
          else
            @timeline_hash.values
          end
        end

        def lineups(which = nil)
          if which
            @lineups_hash[which.to_s]
          else
            @lineups_hash.values
          end
        end

        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def path_base
          "matches/#{ id }"
        end

        def path_summary
          "#{ path_base }/summary"
        end
        def get_summary
          data = api.get_data(path_summary).to_h
          ingest_summary(data)
        end
        def ingest_summary(data)
          update(data)
          data
        end
        def queue_summary
          url, headers, options, timeout = api.get_request_info(path_summary)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_summary)}
        end

        def path_lineups
          "#{ path_base }/lineups"
        end
        def get_lineups
          data = api.get_data(path_lineups).to_h
          ingest_lineups(data)
        end
        def ingest_lineups(data)
          update(data)
          data
        end
        def queue_lineups
          url, headers, options, timeout = api.get_request_info(path_lineups)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_lineups)}
        end

        def path_facts
          "#{ path_base }/funfacts"
        end
        def get_facts
          data = api.get_data(path_facts).to_h
          ingest_facts(data)
        end
        def ingest_facts(data)
          update(data)
          data
        end
        def queue_facts
          url, headers, options, timeout = api.get_request_info(path_facts)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_facts)}
        end

        def path_probabilities
          "#{ path_base }/probabilities"
        end
        def get_probabilities
          data = api.get_data(path_probabilities).to_h
          ingest_probabilities(data)
        end
        def ingest_probabilities(data)
          update(data)
          data
        end
        def queue_probabilities
          url, headers, options, timeout = api.get_request_info(path_probabilities)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_probabilities)}
        end

        def path_timeline
          "#{ path_base }/timeline"
        end
        def get_timeline
          data = api.get_data(path_timeline).to_h
          ingest_timeline(data)
        end
        def ingest_timeline(data)
          update(data, source: :pbp)
          check_newness(:pbp, timeline.last&.updated)
          check_newness(:clock, self.match_seconds.to_s)
          data
        end
        def queue_timeline
          url, headers, options, timeout = api.get_request_info(path_timeline)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_timeline)}
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

      end
    end
  end
end

__END__

"id"=>"sr:match:12090446",
"scheduled"=>"2018-05-20T18:45:00+00:00",
"start_time_tbd"=>true,
"status"=>"not_started",
"tournament_round"=>{"type"=>"group", "number"=>38},
"season"=>{"id"=>"sr:season:42720", "name"=>"Serie A 17/18", "start_date"=>"2017-08-19", "end_date"=>"2018-05-21", "year"=>"17/18", "tournament_id"=>"sr:tournament:23"},
"tournament"=>{"id"=>"sr:tournament:23", "name"=>"Serie A", "sport"=>{"id"=>"sr:sport:1", "name"=>"Soccer"}, "category"=>{"id"=>"sr:category:31", "name"=>"Italy", "country_code"=>"ITA"}},
"competitors"=>
 [{"id"=>"sr:competitor:2793", "name"=>"US Sassuolo", "country"=>"Italy", "country_code"=>"ITA", "abbreviation"=>"SAS", "qualifier"=>"home"},
  {"id"=>"sr:competitor:2702", "name"=>"AS Roma", "country"=>"Italy", "country_code"=>"ITA", "abbreviation"=>"ROM", "qualifier"=>"away"}]

"sport_event_status"=>
 {"status"=>"live",
  "match_status"=>"1st_half",
  "home_score"=>1,
  "away_score"=>0,
  "period"=>1,
  "clock"=>{"match_time"=>"19:25"},
  "clock"=>{"match_time"=>"45:00", "stoppage_time"=>"00:05"}
  "ball_locations"=>[{"x"=>"95", "y"=>"50", "team"=>"away"}, {"x"=>"80", "y"=>"62", "team"=>"home"}, {"x"=>"82", "y"=>"60", "team"=>"home"}, {"x"=>"79", "y"=>"58", "team"=>"home"}]},



m = Sportradar::Api::Soccer::Match.new({"id"=>"sr:match:12090446"}, league_group: 'eu')
res = m.get_summary
res = m.get_lineups
res = m.get_facts
res = m.get_probabilities
res = m.get_timeline
