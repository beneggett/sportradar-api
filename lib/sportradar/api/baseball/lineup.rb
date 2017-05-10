module Sportradar
  module Api
    module Baseball
      class Lineup < Data
        attr_reader :roster, :home, :away
        def initialize(home_team: {}, away_team: {})
          @roster = (home_team['roster'] || []) + (away_team['roster'] || [])
          @home_team_lineup = home_team['lineup']
          @away_team_lineup = away_team['lineup']
          initialize_home
          initialize_away
        end

        def update_home(player, order)
          idx = home.index do |h|
            h['order'] == order
          end
          home[idx] = { 'order' => order }
          home[idx].merge!(player)
        end

        def update_away(player, order)
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
            { 'order' => 0 },
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

        def next_batters(team, last_position, number_of_upcoming_batters)
          if team == 'home'
            upcoming = home.rotate(last_position)
          elsif team == 'away'
            upcoming = home.rotate(last_position)
          end
          upcoming[1..number_of_upcoming_batters]
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
