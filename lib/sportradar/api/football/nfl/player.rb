module Sportradar
  module Api
    module Football
      class Nfl
        class Player < Sportradar::Api::Football::Player

          def api
            @api || Sportradar::Api::Football::Nfl::Api.new
          end

        end
      end
    end
  end
end

__END__

nfl = Marshal.load(File.binread('nfl.bin'));

t = nfl.teams.first;
t.get_roster;
t.players.first
t.players.first.totals

nfl = Marshal.load(File.binread('nfl.bin'));
t = nfl.teams.sample
data = t.get_season_stats(2016);
t.get_roster;
t.players.sample
t.players.sample.totals