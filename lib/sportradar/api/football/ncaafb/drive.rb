module Sportradar
  module Api
    module Football
      class Ncaafb
        class Drive < Sportradar::Api::Football::Drive

          def handle_plays_and_events(data, **opts)
            create_data(@plays_hash,  data['actions'],  klass: Play,  api: api, game: self) if data['actions']
            create_data(@events_hash, data['events'],   klass: Event, api: api, game: self) if data['events']
          end

        end
      end
    end
  end
end
