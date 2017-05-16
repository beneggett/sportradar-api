module Sportradar
  module Api
    module Baseball
      class Lineup < Data
        attr_reader :roster, :home, :away, :game
        def initialize(data, game: nil)
          @game = game
        end

        def update(data, source: nil)
          case source
          when :pbp
          when :summary
            @roster = (data.dig('home', 'roster') || []) + (data.dig('away', 'roster') || [])
            return unless data.dig('home', 'lineup') && data.dig('away', 'lineup')
            @home_team_lineup = data.dig('home', 'lineup')
            @away_team_lineup = data.dig('away', 'lineup')
            initialize_home
            initialize_away
          end
        end

        def update_from_lineup_event(data)
          if data.dig('lineup', 'team_id') == game.home_id
            update_home(find_player(data.dig('lineup', 'player_id')), data.dig('lineup', 'order'))
          elsif data.dig('lineup', 'team_id') == game.away_id
            update_away(find_player(data.dig('lineup', 'player_id')), data.dig('lineup', 'order'))
          end
        end

        def update_home(player, order)
          return if order == 0
          idx = home.index do |h|
            h['order'] == order
          end
          home[idx] = { 'order' => order }
          home[idx].merge!(player)
        end

        def update_away(player, order)
          return if order == 0
          idx = away.index do |h|
            h['order'] == order
          end
          away[idx] = { 'order' => order}
          away[idx].merge!(player)
        end

        def find_player(id)
          roster.detect do |player|
            player['id'] == id
          end
        end

        def initial_lineup
          [
            { 'order' => 1 },
            { 'order' => 2 },
            { 'order' => 3 },
            { 'order' => 4 },
            { 'order' => 5 },
            { 'order' => 6 },
            { 'order' => 7 },
            { 'order' => 8 },
            { 'order' => 9 },
          ]
        end

        def next_batters(team, number_of_upcoming_batters = 3)
          if team == 'home'
            last_at_bat = game.at_bats.select{|at_bat| at_bat.event.half_inning.half == 'B'}.last
            if last_at_bat # first inning
              last_position = @home_team_lineup.detect{|htl| htl['id'] == last_at_bat.hitter_id}&.dig('order')
              upcoming = home.rotate(last_position || 0)
            else
              upcoming = home
            end
          elsif team == 'away'
            last_at_bat = game.at_bats.select{|at_bat| at_bat.event.half_inning.half == 'T'}.last
            if last_at_bat # first inning
              last_position = @away_team_lineup.detect{|atl| atl['id'] == last_at_bat.hitter_id}&.dig('order')
              upcoming = away.rotate(last_position || 0)
            else
              upcoming = away
            end
          end
          upcoming[0..(number_of_upcoming_batters - 1)]
        end

        private

        def initialize_away
          @away = initial_lineup.dup
          @away_team_lineup.sort_by{|t| t['sequence']}.each do |al|
            # al.merge!(find_player(al['id']))
            update_away(find_player(al['id']), al['order'])
          end.sort_by{|al| al['order']}
        end

        def initialize_home
          @home = initial_lineup.dup
          @home_team_lineup.sort_by{|t| t['sequence']}.each do |hl|
            # hl.merge!(find_player(hl['id']))
            update_home(find_player(hl['id']), hl['order'])
          end.sort_by{|hl| hl['order']}
        end

      end
    end
  end
end
