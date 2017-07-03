module Sportradar
  module Api
    module Football
      class Nfl
        class Game < Sportradar::Api::Football::Game

          def update_teams(data)
            @home          = team_class.new(data['home'], api: api, game: self) if data['home'].is_a?(Hash)
            @away          = team_class.new(data['away'], api: api, game: self) if data['away'].is_a?(Hash)
          end


          def path_base
            "games/#{ id }"
          end

          def get_extended_box
            data = api.get_data(path_extended_box)
            ingest_extended_box(data)
          end

          def ingest_extended_box(data)
            data = data
            update(data, source: :extended_box)
            check_newness(:extended_box, @clock)
            data
          # rescue => e
          #   binding.pry
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
g = nfl.games.first;
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