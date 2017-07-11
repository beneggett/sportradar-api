module Sportradar
  module Api
    module Football
      class Ncaafb
        class Week < Sportradar::Api::Football::Week

          def game_class
            Game
          end

        end
      end
    end
  end
end

__END__



ncaafb = Sportradar::Api::Football::Ncaafb.new
ncaafb = Sportradar::Api::Football::Ncaafb.new
res1 = ncaafb.get_schedule;
res2 = ncaafb.get_weekly_schedule;
