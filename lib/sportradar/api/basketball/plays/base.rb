module Sportradar
  module Api
    module Basketball
      class Play
        class Base < Data
          attr_accessor :response, :id, :clock, :event_type, :description, :statistics, :score, :team_id, :player_id, :quarter, :half, :updated, :location, :possession, :on_court, :game_seconds, :identifier
          alias :type :event_type

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = data['id']

            @quarter  = opts[:quarter].sequence.to_i  rescue opts[:quarter].to_i
            @half     = opts[:half].sequence.to_i     rescue opts[:half].to_i

            update(data, **opts)
          end

          def period
            @quarter.nonzero? || @half.nonzero?
          end

          # def game
          #   quarter.game
          # end
          def display_type
            ''
          end

          def scoring_play?
            points.nonzero?
          end
          def timeout?
            false
          end
          def media_timeout?
            false
          end
          def quarter_break?
            false
          end
          def halftime?
            false
          end
          def end_of_period?
            false
          end
          def end_of_regulation?
            false
          end
          def end_of_ot?
            false
          end
          def base_key
            nil
          end

          def points
            0
          end

          def ==(other)
            id == other.id && description == other.description
          end

          def clock_seconds
            m,s = @clock.split(':')
            m.to_i * 60 + s.to_i
          end
          def nba_game_seconds
            ([quarter, 4].min * 720) + ([quarter - 4, 0].max * 300) - clock_seconds # seconds elapsed in game, only works for NBA
          end

          private def ncaa_game_seconds
            ([half, 2].min * 1200) + ([half - 2, 0].max * 300) - clock_seconds # seconds elapsed in game, only works for NBA
          end

          def update(data, **opts)
            @event_type  = data['event_type']  # "lineupchange",
            @clock       = data['clock']       # "12:00",
            @updated     = data['updated']     # "2016-10-26T00:07:52+00:00",
            @description = data['description'] # "Cavaliers lineup change (Richard Jefferson, Kyrie Irving, Mike Dunleavy, Channing Frye, LeBron James)",
            @attribution = data['attribution'] # {"name"=>"Cavaliers", "market"=>"Cleveland", "id"=>"583ec773-fb46-11e1-82cb-f4ce4684ea4c", "team_basket"=>"left"},
            @team_id     = data.dig('attribution', "id")
            @location    = data['location']    # {"coord_x"=>"0", "coord_y"=>"0"},
            @possession  = data['possession']  # {"name"=>"Knicks", "market"=>"New York", "id"=>"583ec70e-fb46-11e1-82cb-f4ce4684ea4c"},
            # @on_court    = data['on_court']    # hash

            handle_time(data, **opts)
            parse_statistics(data) if data['statistics']
          end

          def handle_time(data, **opts)
            @game_seconds = if opts[:quarter]
              @quarter  = opts[:quarter].sequence.to_i rescue opts[:quarter].to_i
              @identifier = "#{quarter}_#{(720 - clock_seconds).to_s.rjust(3, '0')}".to_i
              nba_game_seconds
            elsif opts[:half]
              @half  = opts[:half].sequence.to_i rescue opts[:half].to_i
              @identifier = "#{quarter}_#{(1200 - clock_seconds).to_s.rjust(3, '0')}".to_i
              ncaa_game_seconds
            end
          end

          def parse_statistics(data)
            return unless data['statistics']
            @statistics = data['statistics']
            stat = @statistics.detect { |hash| hash['type'] == base_key }
            # stat = data.dig('statistics', base_key) rescue data.dig('statistics', 0, base_key)
            # stat = stat[0] if stat.is_a?(Array) # sometimes SR has an array of identical assist hashes
            @team = stat['team']
            @team_id = @team['id'] if @team
            @player = stat['player']
            @player_id = @player['id'] if @player
          rescue => e
            puts e
            # binding.pry
          end

        end
      end
    end
  end
end
