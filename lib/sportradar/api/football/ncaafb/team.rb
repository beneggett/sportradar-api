module Sportradar
  module Api
    module Football
      class Ncaafb
        class Team < Sportradar::Api::Football::Team

          def alias
            id
          end

          def used_timeouts
            3 - remaining_timeouts.to_i
          end

          def players
            get_roster if @players_hash.empty?
            @players_hash.values
          end
          alias :roster :players
          
          def player_class
            Player
          end

          def path_roster
            "#{ path_base }/roster"
          end
          def path_season_stats(year = season_year, season = ncaafb_season)
            "#{path_base}/#{year}/#{ncaafb_season}/statistics"
          end

          def api
            @api || Sportradar::Api::Football::Ncaafb::Api.new
          end
          def ncaafb_season
            @type || default_season
          end

        end

      end
    end
  end
end

__END__

ncaafb = Marshal.load(File.binread('ncaafb.bin'));

t = ncaafb.teams.first
data = t.get_season_stats
data = t.get_season_stats(2016)
t.players.count
