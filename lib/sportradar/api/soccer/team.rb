module Sportradar
  module Api
    module Soccer
      class Team < Data
        attr_accessor :tournament_id, :venue, :player_stats
        attr_reader :id, :league_group, :name, :country, :country_code, :abbreviation, :qualifier
        alias :alias :abbreviation
        alias :market :name
        alias :display_name :name
        alias :full_name :name
        attr_reader :team_stats, :jerseys, :manager, :statistics

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id']
          @api          = opts[:api]
          @league_group = league_group || data['league_group'] || @api&.league_group

          @players_hash = {}
          @player_stats = {}
          @matches_hash = {}

          update(data, **opts)
        end

        def update(data, **opts)
          @id           = data['id'] if data['id']
          @league_group = opts[:league_group] || data['league_group'] || @league_group
          get_tournament_id(data, **opts)

          if data["team"]
            update(data["team"])
          end

          @name         = data['name']              if data['name']
          @country      = data['country']           if data['country']
          @country_code = data['country_code']      if data['country_code']
          @abbreviation = data['abbreviation']      if data['abbreviation']
          @qualifier    = data['qualifier']         if data['qualifier']
          @venue        = Venue.new(data['venue'])  if data['venue']

          create_data(@players_hash, data['players'], klass: Player, api: api, team: self) if data['players']
          create_data(@players_hash, data['player_statistics'], klass: Player, api: api, team: self) if data['player_statistics']

          # TODO team statistics
          @team_stats    = data['team_statistics']   if data['team_statistics']

          create_data(@matches_hash, Soccer.parse_results(data['results']), klass: Match, api: api, team: self) if data['results']
          create_data(@matches_hash, data['schedule'],  klass: Match, api: api, team: self) if data['schedule']

          # TODO roster
          @jerseys      = data['jerseys']     if data['jerseys']
          @manager      = data['manager']     if data['manager']
          @statistics   = data['statistics']  if data['statistics']
        end

        def get_tournament_id(data, **opts)
          @tournament_id ||= if opts[:tournament]
            opts[:tournament].id
          elsif opts[:season]
            opts[:season].tournament_id
          elsif opts[:match]
            opts[:match].tournament_id
          elsif data['tournament_id']
            data['tournament_id']
          elsif data['tournament']
            data.dig('tournament', 'id')
          elsif data['season']
            data.dig('season', 'tournament_id')
          end
        end

        def players
          @players_hash.values
        end

        def matches
          @matches_hash.values
        end

        def api
          @api || Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def path_base
          "teams/#{ id }"
        end

        def path_roster
          "#{ path_base }/profile"
        end
        def get_roster
          data = api.get_data(path_roster).to_h
          ingest_roster(data)
        end
        def ingest_roster(data)
          update(data)
          data
        end
        def queue_roster
          url, headers, options, timeout = api.get_request_info(path_roster)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_roster)}
        end
        def update_player_stats(player, stats, game = nil)
          game ? game.update_player_stats(player, stats) : @player_stats.merge(player.id => stats.merge(player: player))
        end
        def path_results
          "#{ path_base }/results"
        end
        def get_results
          data = api.get_data(path_results).to_h
          ingest_results(data)
        end
        def ingest_results(data)
          update(data)
          data
        end
        def queue_results
          url, headers, options, timeout = api.get_request_info(path_results)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_results)}
        end

        def path_schedule
          "#{ path_base }/schedule"
        end
        def get_schedule
          data = api.get_data(path_schedule).to_h
          ingest_schedule(data)
        end
        def ingest_schedule(data)
          update(data)
          data
        end
        def queue_schedule
          url, headers, options, timeout = api.get_request_info(path_schedule)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
        end

        def path_statistics(tourn_id = self.tournament_id)
          "tournaments/#{ tourn_id }/#{ path_base }/statistics"
        end
        def get_statistics(tourn_id = self.tournament_id)
          data = api.get_data(path_statistics(tourn_id)).to_h
          ingest_statistics(data)
        end
        def ingest_statistics(data)
          update(data)
          data
        end
        def queue_statistics
          url, headers, options, timeout = api.get_request_info(path_statistics)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_statistics)}
        end

      end
    end
  end
end

__END__

group = Sportradar::Api::Soccer::Group.new(league_group: 'eu')
res = group.get_tournaments;
tour = group.tournaments.sample;
tour = group.tournament("sr:tournament:17");
tour.get_results;
match = tour.matches.first;
res = match.get_summary;
team = match.team(:home)
res = match.get_lineups

team = Sportradar::Api::Soccer::Team.new({"id"=>"sr:competitor:42"}, league_group: 'eu')
