module Sportradar
  module Api
    module Football
      class Nfl
        class Quarter < Sportradar::Api::Football::Quarter

          def drive_class
            Drive
          end

          def overtime?
            @sequence > 4
          end

          def self.period_index
            'sequence'
          end

        end
      end
    end
  end
end
