module Sportradar
  module Api
    module Football
      class Ncaafb
        class Player < Sportradar::Api::Football::Player

          def api
            @api || Sportradar::Api::Football::Ncaafb::Api.new
          end

        end
      end
    end
  end
end

__END__

ncaafb = Marshal.load(File.binread('ncaafb.bin'));

t = ncaafb.teams.first;
t.get_roster;
t.players.first
t.players.first.totals

ncaafb = Marshal.load(File.binread('ncaafb.bin'));
t = ncaafb.teams.sample
data = t.get_season_stats(2016);
t.get_roster;
t.players.sample
t.players.sample.totals