module Sportradar
  module Api
    module Football
      class Nfl
        class Drive < Sportradar::Api::Football::Drive

          def handle_plays_and_events(data, **opts)
            things = (Array(data['events']) + Array(data['actions'])).group_by { |hash| hash['type'] }

            create_data(@plays_hash,  things['play'],  klass: Play,  api: api, game: self) if things['play']
            create_data(@events_hash, things['event'], klass: Event, api: api, game: self) if things['setup']
            create_data(@events_hash, things['event'], klass: Event, api: api, game: self) if things['event']
          end

        end
      end
    end
  end
end
