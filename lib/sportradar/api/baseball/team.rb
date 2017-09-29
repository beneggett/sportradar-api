module Sportradar
  module Api
    module Baseball
      class Team < Data
        attr_accessor :response, :id, :market, :name, :alias, :full_name, :venue, :records, :player_stats, :team_stats

        def initialize(data, **opts)
          @response = data # comment this out when done developing
          @api      = opts[:api]
          @id = data['id']

          @games_hash   = {}
          @players_hash = {}
          @player_stats = {}
          @records      = {}
          @stats        = nil
          @runs         = nil

          update(data, **opts)
        end

        def update(data, **opts)
          handle_names(data)
          @venue    = Venue.new(data['venue']) if data['venue']

          @alias    = data['abbr']                if data['abbr']
          @runs     = data['runs'].to_i           if data['runs']
          # # @home     = data['home'] == 'true'        if data['home']
          # # @away     = data['away'] == 'true'        if data['away']
          # # @scoring  = data.dig('scoring', 'quarter') if data.dig('scoring', 'quarter')

          parse_records(data)                               if data['win']
          parse_players(data.dig('players'), opts[:game])   if data.dig('players')

          if opts[:game]
            # opts[:game].update_from_team(id, "runs"=>6)
            # opts[:game].update_from_team(id, "hits"=>11)
            # opts[:game].update_from_team(id, "errors"=>1)
            # opts[:game].update_from_team(id, "win"=>11)
            # opts[:game].update_from_team(id, "loss"=>16)
            # opts[:game].update_from_team(id, "probable_pitcher"=>{"jersey_number"=>"45", "id"=>"c1f19b5a-9dee-4053-9cad-ee4196f921e1", "win"=>2, "loss"=>3, "era"=>5.0})
            # opts[:game].update_from_team(id, "starting_pitcher"=>{"last_name"=>"Cotton", "first_name"=>"Jharel", "preferred_name"=>"Jharel", "jersey_number"=>"45"})
            # opts[:game].update_from_team(id, "current_pitcher"=>{"last_name"=>"Dull", "first_name"=>"Ryan", "preferred_name"=>"Ryan", "jersey_number"=>"66"})
            # add_game(opts[:game])
            # opts[:game].update_score(id => @runs)             if @runs
            opts[:game].update_stats(self, data['statistics'])  if data['statistics']
          end
        end
        def handle_names(data)
          # need to do some more work here
          @name = data['name'] if data['name']
          if data['name'] && data['market']
            @market = data['market']
            @full_name = [@market, data['name']].join(' ')
          elsif data['name'] && !data.key?('market')
            @full_name = data['name']
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

        def players
          get_roster if @players_hash.empty?
          @players_hash.values
        end
        alias :roster :players


        # parsing response data

        def parse_players(data, game)
          create_data(@players_hash, data, klass: Player, api: api, team: self, game: game)
        end
        def update_player_stats(player, stats, game = nil)
          game ? game.update_player_stats(player, stats) : @player_stats.merge!(player.id => stats.merge(player: player))
        end
        def parse_records(data)
          @records['overall'] = Record.new(data, type: 'overall')
        end

        def parse_season_stats(data)
          @team_stats = data.dig('statistics')
          update(data)
          player_data = data.dig('players')
          create_data(@players_hash, player_data, klass: Player, api: api, team: self)
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

        def api
          @api || Sportradar::Api::Baseball::Mlb::Api.new
        end

      end
    end
  end
end
