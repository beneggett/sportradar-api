module Sportradar
  module Api
    module Basketball
      class Team < Data
        attr_accessor :response, :id, :market, :name, :alias, :full_name, :venue, :records, :player_stats, :team_stats, :seed

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

        def profile
          Profile.new(self)
        end

        def update(data, **opts)
          handle_names(data)
          @venue    = Venue.new(data['venue']) if data['venue']

          @seed     = data['seed'].to_i             if data['seed']
          @alias    = data['alias']                 if data['alias']
          @points   = data['points'].to_i           if data['points']
          # @home     = data['home'] == 'true'        if data['home']
          # @away     = data['away'] == 'true'        if data['away']
          # @scoring  = data.dig('scoring', 'quarter') if data.dig('scoring', 'quarter')

          parse_records(data)                                          if data['records']
          # binding.pry if data['players']
          parse_players(data.dig('players'), opts[:game])   if data.dig('players')
          # parse_stats(data['statistics'])                             if data['statistics']
          if opts[:game]
            add_game(opts[:game])
            opts[:game].update_score(id => @points)             if @points
            opts[:game].update_stats(self, data['statistics'])  if data['statistics']
          end
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
        def parse_records(data)
          @records['overall'] = Record.new(data, type: 'overall')
          data['records'].each { |record| @records[record['record_type']] = Record.new(record, type: record['record_type']) }
        end

        def parse_season_stats(data)
          @team_stats = data.dig('own_record')
          update(data)
          player_data = data.dig('players')
          create_data(@players_hash, player_data, klass: player_class, api: api, team: self)
          data
        end


        # data retrieval

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

        def get_season_stats(year = Date.today.year)
          data = api.get_data(path_season_stats(year)).to_h
          ingest_season_stats(data)
        end
        def ingest_season_stats(data)
          parse_season_stats(data)
        end
        def queue_season_stats
          url, headers, options, timeout = api.get_request_info(path_season_stats)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_season_stats)}
        end

        # url path helpers
        def path_base
          "teams/#{ id }"
        end
        def path_base_stats(season_year = api.default_year, default_season = api.default_season)
          "seasontd/#{season_year}/#{default_season}/teams/#{id}"
        end
        def path_roster
          "#{ path_base }/profile"
        end
        def path_season_stats(year)
          "#{ path_base_stats(year) }/statistics"
        end

      end
    end
  end
end
