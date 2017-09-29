module Sportradar
  module Api
    module Hockey
      class Record < Data
        attr_accessor :id, :team, :games_played, :wins, :losses, :overtime_losses, :win_pct, :points, :regulation_wins, :shootout_wins, :shootout_losses, :goals_for, :goals_against, :goal_diff, :powerplays, :powerplay_goals, :powerplay_pct, :powerplays_against, :powerplay_goals_against, :penalty_killing_pct, :streak

        def initialize(data, type: 'overall', **opts)
          @team     = opts[:team]
          @type     = type

          update(data, **opts)
        end

        def update(data, **opts)
          @games_played             =  data['games_played']
          @wins                     =  data['wins']
          @losses                   =  data['losses']
          @overtime_losses          =  data['overtime_losses']
          @win_pct                  =  data['win_pct']
          @points                   =  data['points']
          @regulation_wins          =  data['regulation_wins']
          @shootout_wins            =  data['shootout_wins']
          @shootout_losses          =  data['shootout_losses']
          @goals_for                =  data['goals_for']
          @goals_against            =  data['goals_against']
          @goal_diff                =  data['goal_diff']
          @powerplays               =  data['powerplays']
          @powerplay_goals          =  data['powerplay_goals']
          @powerplay_pct            =  data['powerplay_pct']
          @powerplays_against       =  data['powerplays_against']
          @powerplay_goals_against  =  data['powerplay_goals_against']
          @penalty_killing_pct      =  data['penalty_killing_pct']
          @streak                   =  data['streak']
        end

        def <=>(other)
          self.win_pct <=> other.win_pct
        end

      end
    end
  end
end

__END__

"games_played"=>82,
"wins"=>46,
"losses"=>23,
"overtime_losses"=>13,
"win_pct"=>0.561,
"points"=>105,
"regulation_wins"=>43,
"shootout_wins"=>3,
"shootout_losses"=>3,
"goals_for"=>223,
"goals_against"=>200,
"goal_diff"=>23,
"powerplays"=>251,
"powerplay_goals"=>47,
"powerplay_pct"=>18.7,
"powerplays_against"=>281,
"powerplay_goals_against"=>42,
"penalty_killing_pct"=>85.1,
"streak"=>{"kind"=>"win", "length"=>4},
