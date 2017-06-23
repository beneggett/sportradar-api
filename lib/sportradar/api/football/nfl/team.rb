module Sportradar
  module Api
    module Football
      class Nfl
        class Team < Sportradar::Api::Football::Team

          def players
            get_roster if @players_hash.empty?
            @players_hash.values
          end
          alias :roster :players
          
          def player_class
            Player
          end

          def path_season_stats(year = season_year, season = nfl_season)
            "seasontd/#{year}/#{nfl_season}/teams/#{ id }/statistics"
          end

          def api
            @api || Sportradar::Api::Football::Nfl.new
          end
          def nfl_season
            @type || default_season
          end

        end

      end
    end
  end
end

__END__

nfl = Marshal.load(File.binread('nfl.bin'));

t = nfl.teams.first
data = t.get_season_stats
data = t.get_season_stats(2016)
t.players.count
