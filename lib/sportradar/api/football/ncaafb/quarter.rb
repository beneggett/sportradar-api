module Sportradar
  module Api
    module Football
      class Ncaafb
        class Quarter < Sportradar::Api::Football::Quarter

          def drive_class
            Drive
          end

        end
      end
    end
  end
end
