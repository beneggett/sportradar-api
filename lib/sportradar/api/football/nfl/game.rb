module Sportradar
  module Api
    module Football
      class Nfl
        class Game < Sportradar::Api::Football::Game


          def update_teams(data)
            if data['summary']
              @home.update(data.dig('summary', 'home'), game: self)
              @away.update(data.dig('summary', 'away'), game: self)
            else
              @home.update(data['home'], api: api, game: self) if data['home'].is_a?(Hash)
              @away.update(data['away'], api: api, game: self) if data['away'].is_a?(Hash)
              @home_alias    = data['home'] if data['home'].is_a?(String) # this might actually be team ID and not alias. check in NFL
              @away_alias    = data['away'] if data['away'].is_a?(String) # this might actually be team ID and not alias. check in NFL
            end
          end


          def path_base
            "games/#{ id }"
          end

          def team_class
            Team
          end
          def period_class
            Quarter
          end

          def period_key
            'periods'
          end

          def quarter_class
            Sportradar::Api::Football::Nfl::Quarter
          end

          def drive_class
            Sportradar::Api::Football::Nfl::Drive
          end

          def api
            @api || Sportradar::Api::Football::Nfl::Api.new
          end

        end
      end
    end
  end
end

__END__


nfl = Sportradar::Api::Football::Nfl.new
nfl = Sportradar::Api::Football::Nfl.new(year: 2016)
gg = nfl.games;
tt = nfl.teams;
File.binwrite('nfl.bin', Marshal.dump(nfl))
nfl = Marshal.load(File.binread('nfl.bin'));
g1 = nfl.games.sample;
g = gg.first;
g = gg.sample;
g.week_number
g.year
g.type
g.path_pbp
res = g.get_pbp;

nfl = Marshal.load(File.binread('nfl.bin'));
g = nfl.games.first;
res = g.get_pbp;
g.quarters.first.drives[1]

g = gg.detect{|g| g.id == "" } # overtime game

stats = %i[defense extra_points field_goals fumbles int_returns kickoffs misc_returns passing penalties punt_returns punts receiving rushing]
stats.all? { |st| g.stats(:home).send(st) }
