module Sportradar
  module Api
    module Football
      class Ncaafb
        class Drive < Sportradar::Api::Football::Drive

          def over?
            plays.last&.parsed_ending || (overtime? && ['End of Quarter', 'End of Game'].include?(plays.last&.description))
          end

          def handle_plays_and_events(data, **opts)
            create_data(@plays_hash,  data['actions'],  klass: Play,  api: api, drive: self) if data['actions']
            create_data(@events_hash, data['events'],   klass: Event, api: api, drive: self) if data['events']
          end

          def play_count
            plays.count(&:counted_play?)
          end

          def gain
            Array(plays.select(&:counted_play?)).sum do |play|
              Array(play.players).sum do |p|
                p.dig('passing', 'yds').to_i + p.dig('rushing', 'yds').to_i
              end
            end
          end

        end
      end
    end
  end
end
# e = Event.find 17632;
# sc = e.sportconnector_game;
# dr = sc.pbp[-3]
# pl = dr.plays.last
