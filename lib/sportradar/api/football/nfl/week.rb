module Sportradar
  module Api
    module Football
      class Nfl
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



nfl = Sportradar::Api::Football::Nfl.new
nfl = Sportradar::Api::Football::Nfl.new
res1 = nfl.get_schedule;
res2 = nfl.get_weekly_schedule;
