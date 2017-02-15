module Sportradar
  module Api
    module Basketball
      class Record < Data
        attr_accessor :id, :team, :wins, :losses, :win_pct, :points_for, :points_against, :point_diff, :games_behind, :streak

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
          @points_for     = data['points_for']
          @points_against = data['points_against']
          @point_diff     = data['point_diff']
          @games_behind   = data['games_behind']
          @streak         = data['streak']
        end

      end
    end
  end
end
