module Sportradar
  module Api
    module Basketball
      class Nba
        class Game < Sportradar::Api::Basketball::Game

          # NBA specific

          def team_class
            Team
          end
          def period_class
            Quarter
          end

          def period_name
            'quarter'
          end
          alias :quarter :period
          alias :quarters :periods

          def api
            @api ||= Sportradar::Api::Basketball::Nba::Api.new
          end

          def sim!
            @api = api.sim!
            self
          end

        end
      end
    end
  end
end

__END__

ss = sr.schedule;
sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
sd = sr.daily_schedule(Date.yesterday);
sd = sr.daily_schedule(Date.new(2017, 1, 20));
g = sd.games.first;
box = g.get_box;
pbp = g.get_pbp;
g.quarters.size
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