module Sportradar
  module Api
    module Football
      class Record < Data
        attr_accessor :id, :team, :wins, :losses, :win_pct, :points_for, :points_against, :point_diff, :games_behind, :streak

        def initialize(data, type: 'overall', **opts)
          @team     = opts[:team]
          @type     = type

          update(data, **opts)
        end

        def update(data, **opts)
          @wins           = data['wins']
          @losses         = data['losses']
          @win_pct        = data['win_pct']
          @points_for     = data['points_for']
          @points_against = data['points_against']
          @point_diff     = data['point_diff']
          @games_behind   = data['games_behind']
          @streak         = data['streak']
        end

        def <=>(other)
          self.win_pct <=> other.win_pct
        end

      end
    end
  end
end

__END__

"wins"=>14,
"losses"=>2,
"ties"=>0,
"win_pct"=>0.875,
"points_for"=>441,
"points_against"=>250,
"points_rank"=>4,
"touchdown_diff"=>24,
"conf_h2h"=>0,
"rank"=>{"conference"=>1, "division"=>1},
"streak"=>{"type"=>"win", "length"=>7, "desc"=>"Won 7"},
"strength_of_schedule"=>{"sos"=>0.439453, "wins"=>113, "total"=>256},
"strength_of_victory"=>{"sov"=>0.424, "wins"=>95, "total"=>224},
