module Sportradar
  module Api
    module Football
      class Ncaafb
        class Game < Sportradar::Api::Football::Game

          def path_base
            "#{ year }/#{ type }/#{ week_number.to_s.rjust(2, '0') }/#{ away_alias }/#{ home_alias }"
          end

          def team_class
            Team
          end
          def period_class
            Quarter
          end

          def period_name
            'quarter'
          end

          def api
            @api || Sportradar::Api::Football::Ncaafb.new
          end

        end
      end
    end
  end
end

__END__

File.binwrite('ncaafb.bin', Marshal.dump(ncaafb))
ncaafb = Marshal.load(File.binread('ncaafb.bin'));

ncaafb = Sportradar::Api::Football::Ncaafb::Hierarchy.new(year: 2016)
ncaafb = Sportradar::Api::Football::Ncaafb::Hierarchy.new
gg = ncaafb.games;
g = gg.first;
g = gg.sample;
g.week_number
g.year
g.type
g.path_pbp
g.get_pbp
