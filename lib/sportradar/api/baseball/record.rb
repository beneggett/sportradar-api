module Sportradar
  module Api
    module Baseball
      class Record < Data
        attr_accessor :id, :team, :wins, :losses, :win_pct, :runs_for, :runs_against, :run_diff, :games_behind, :streak

        def initialize(data, type: 'overall', **opts)
          @team     = opts[:team]
          @type     = type

          update(data, **opts)
        end

        def profile
          Profile.new(self)
        end

        def update(data, **opts)
          @wins           = data['wins'].to_i
          @losses         = data['losses'].to_i
          @win_pct        = data['win_pct'].to_f
          @runs_for       = data['runs_for']
          @runs_against   = data['runs_against']
          @run_diff       = data['run_diff']
          @games_behind   = data['games_behind']
          @streak         = data['streak']
        end

      end
    end
  end
end
