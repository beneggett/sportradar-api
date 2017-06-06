module Sportradar
  module Api
    module Football
      class Ncaafb
        class Game < Sportradar::Api::Football::Game

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

ncaafb = Sportradar::Api::Ncaafb::Hierarchy.new;
