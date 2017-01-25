module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Game < Sportradar::Api::Basketball::Game

          # NCAA MB specific

          def team_class
            Team
          end
          def period_class
            Half
          end

          def period_name
            'half'
          end
          alias :half :period
          alias :halfs :periods

          def api
            @api || Sportradar::Api::Basketball::Ncaamb.new
          end

        end
      end
    end
  end
end

__END__

ss = sr.schedule;
sr = Sportradar::Api::Basketball::Ncaamb.new
gid = "29111b80-992d-4e32-a88d-220fb4bd3121"
g = Sportradar::Api::Basketball::Ncaamb::Game.new({'id' => gid}, api: sr)
sd = sr.daily_schedule;
sd = sr.daily_schedule(Date.new(2017,1,21))
g = sd.games.detect{ |g| g.id == gid }
g = sd.games.last;
box = g.get_box;
pbp = g.get_pbp;
g.periods.size
g.plays.size

Sportradar::Api::Basketball::Nba::Team.all.size # => 32 - includes all star teams

g1 = sd.games.first;
sd = sr.schedule;
sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
sd = sr.daily_schedule(Date.yesterday);
g = sd.games.last;
g.get_summary;
g.get_pbp;
g.get_box;
g.scoring
g.get_pbp; g.changed? :pbp