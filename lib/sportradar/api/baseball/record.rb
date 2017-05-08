module Sportradar
  module Api
    module Baseball
      class Record < Data
        attr_accessor :id, :team, :wins, :losses, :win_pct, :streak, :games_back #, :runs_for, :runs_against, :run_diff, :games_behind, :streak
        alias :games_behind :games_back

        def initialize(data, type: 'overall', **opts)
          @team     = opts[:team]
          @type     = type

          update(data, **opts)
        end

        def profile
          Profile.new(self)
        end

        def update(data, **opts)
          @wins               = data["win"]
          @losses             = data["loss"]
          @win_pct            = data["win_p"]
          @home_win           = data["home_win"]
          @home_loss          = data["home_loss"]
          @away_win           = data["away_win"]
          @away_loss          = data["away_loss"]
          @streak             = data["streak"]
          @e_win              = data["e_win"]
          @e_loss             = data["e_loss"]
          @c_win              = data["c_win"]
          @c_loss             = data["c_loss"]
          @w_win              = data["w_win"]
          @w_loss             = data["w_loss"]
          @al_win             = data["al_win"]
          @al_loss            = data["al_loss"]
          @last_10_won        = data["last_10_won"]
          @last_10_lost       = data["last_10_lost"]
          @games_back         = data["games_back"]
          @wild_card_back     = data["wild_card_back"]
          @elimination_number = data["elimination_number"]
        end

      end
    end
  end
end
