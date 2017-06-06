module Sportradar
  module Api
    module Football
      class Ncaafb
        class Team < Sportradar::Api::Football::Team

          def players
            get_roster if @players_hash.empty?
            @players_hash.values
          end
          alias :roster :players
          
          def player_class
            Player
          end

          def path_roster
            "#{ path_base }/roster"
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

sr = Sportradar::Api::Ncaafb::Hierarchy.new;
