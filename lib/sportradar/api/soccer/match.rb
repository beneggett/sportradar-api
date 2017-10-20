module Sportradar
  module Api
    module Soccer
      class Match < Data
        attr_reader :id, :league_group, :scheduled, :start_time_tbd, :status, :tournament_round, :match_status, :venue
        attr_reader :home_score, :away_score, :winner_id, :aggregate_home_score, :aggregate_away_score, :aggregate_winner_id
        attr_reader :referee, :weather_info, :coverage_info
        attr_reader :home, :away, :tournament_id

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id']
          @api          = opts[:api]

          @league_group = league_group || data['league_group'] || @api&.league_group

          @timeline_hash = {}
          @lineups_hash  = {}
          get_tournament_id(data, **opts)
          @home          = Team.new({}, api: api, match: self)
          @away          = Team.new({}, api: api, match: self)
          @teams_hash    = { away: @away, home: @home }

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
          @winner_id        = data['winner_id']                     if data['winner_id']

          @aggregate_home_score = data['aggregate_home_score']      if data['aggregate_home_score']
          @aggregate_away_score = data['aggregate_away_score']      if data['aggregate_away_score']
          @aggregate_winner_id  = data['aggregate_winner_id']       if data['aggregate_winner_id']
          create_data(@timeline_hash, data['timeline'], klass: Event, api: api)
          # @season
          # @tournament
          if data['competitors']
            update_teams(data['competitors'])
          end

          # parse_nested_data(data)
        end

        def update_teams(data)
          home_hash = data.detect { |team_hash| team_hash["qualifier"] == "home" || team_hash["team"] == "home" }
          away_hash = (data - [home_hash]).first
          if home_hash && away_hash
            @home.update(home_hash, match: self)
            @away.update(away_hash, match: self)
            @teams_hash[@home.id] = @home
            @teams_hash[@away.id] = @away
          end
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
          "#{ path_base }/facts"
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
          update(data)
          data
        end
        def queue_timeline
          url, headers, options, timeout = api.get_request_info(path_timeline)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_timeline)}
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


m = Sportradar::Api::Soccer::Match.new({"id"=>"sr:match:12090446"}, league_group: 'eu')
res = m.get_summary
res = m.get_lineups
res = m.get_facts
res = m.get_probabilities
res = m.get_timeline
