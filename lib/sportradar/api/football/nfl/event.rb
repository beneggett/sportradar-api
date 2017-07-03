module Sportradar
  module Api
    module Football
      class Nfl
        class Event < Sportradar::Api::Football::Event

          def self.new(data, **opts)
            if data['type'] == 'play'
              Play.new(data, **opts)
            else
              super(data, **opts)
            end
          end

        end
      end
    end
  end
end
