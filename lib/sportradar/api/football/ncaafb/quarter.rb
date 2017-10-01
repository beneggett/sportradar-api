module Sportradar
  module Api
    module Football
      class Ncaafb
        class Quarter < Sportradar::Api::Football::Quarter

          def drive_class
            Drive
          end

          def overtime?
            @number > 4
          end

          def self.period_index
            'number'
          end

        end
      end
    end
  end
end
