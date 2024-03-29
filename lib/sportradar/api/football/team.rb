module Sportradar
  module Api
    module Football
      class Team < Data
        attr_accessor :response, :id, :market, :name, :alias, :full_name, :venue, :records, :player_stats, :team_stats, :seed, :season, :type, :stats, :used_timeouts, :remaining_timeouts

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @games_hash   = {}
          @players_hash = {}
          @player_stats = {}
          @records      = {}
          @stats        = nil
          @points       = nil

          case data
          when String
            @id = data
          when Hash
            @id = data['id']
            update(data, **opts)
          end
        end

        def update(data, **opts)
          handle_names(data)
          @id = data['id'] || @id

          @venue    = Venue.new(data['venue']) if data['venue']

          @seed     = data['seed'].to_i             if data['seed']
          @alias    = data['alias']                 if data['alias']
          @points   = data['points'].to_i           if data['points'] && data['points'].kind_of?(Integer)
          @used_timeouts      = data['used_timeouts']       if data['used_timeouts']
          @remaining_timeouts = data['remaining_timeouts']  if data['remaining_timeouts']

          parse_records(data)                                          if data['records'] || data['overall']
          parse_players(data.dig('players'), opts[:game])   if data.dig('players')
          # parse_stats(data['statistics'])                             if data['statistics']
          if opts[:game]
            add_game(opts[:game])
            opts[:game].update_score(id => @points)             if @points
            if data['statistics']
              @stats = Sportradar::Api::Football::GameStats.new(data['statistics'])
              opts[:game].update_stats(self, @stats)
            end
          end
        end

        def timeouts
          {'used' => used_timeouts, 'remaining' => remaining_timeouts}
        end
        def handle_names(data)
          # need to do some more work here
          @name = data['name'] if data['name']
          if data['name'] && !data.key?('market')
            @full_name = data['name']
          elsif data['name'] && data['market']
            @market = data['market']
            @full_name = [@market, data['name']].join(' ')
          end
        end

        def record(type = 'overall')
          @records[type]
        end

        def games
          @games_hash.values
        end
        def add_game(game)
          @games_hash[game.id] = game.id if game
        end

        # def parse_stats(data)
        #   @stats = data
        # end

        def players
          get_roster if @players_hash.empty?
          @players_hash.values
        end
        alias :roster :players
        def parse_players(data, game)
          create_data(@players_hash, data, klass: player_class, api: api, team: self, game: game)
        end
        def update_player_stats(player, stats, game = nil)
          game ? game.update_player_stats(player, stats) : @player_stats.merge!(player.id => stats.merge(player: player))
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


        def get_season_stats(year = default_year)
          data = api.get_data(path_season_stats(year)).to_h
          ingest_season_stats(data)
        end
        def ingest_season_stats(data)
          parse_season_stats(data)
        end

        # def ingest_season_stats(data)
        #   update(data, source: :teams)
        #   data
        # end

        def queue_season_stats(year = default_year)
          url, headers, options, timeout = api.get_request_info(path_season_stats(year))
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_season_stats)}
        end

        def parse_records(data)
          @records['overall'] = Record.new(data, type: 'overall')
          data['records'].each { |record| @records[record['record_type']] = Record.new(record, type: record['record_type']) }
        end

        def parse_season_stats(data)
          @team_stats = data.dig('statistics')
          update(data)
          player_data = data.dig('players')
          create_data(@players_hash, player_data, klass: player_class, api: api, team: self)
          data
        end

        def path_base
          "teams/#{ id }"
        end
        def path_base_stats(year = season_year, season = default_season)
          "seasons/#{year}/#{season}/teams/#{id}"
        end
        def path_roster
          "#{ path_base }/profile" # nfl is profile, ncaa is roster
        end
        def path_season_stats(year = season_year, season = default_season)
          "#{ path_base_stats(year, season) }/statistics"
        end


        def season_year
          @season || default_year
        end
        alias :year :season_year

        private
        def default_year
          (Date.today - 60).year
        end
        def default_date
          Date.today
        end
        def default_season
          'reg'
        end

      end
    end
  end
end
