module Sportradar
  module Api
    module Football
      class Ncaafb
        class Drive < Sportradar::Api::Football::Drive

          alias :team_id :team

          def update(data, **opts)
            super.tap {
              if opts[:game]
                game_drives = opts[:game].drives
                @sequence = (game_drives.index(self) || game_drives.size) + 1
              end
            }
          end

          def duration_seconds
            start_time = plays.first&.clock_seconds
            end_time   = plays.last&.clock_seconds
            if end_time > start_time
              start_time + 900 - end_time
            else
              start_time - end_time
            end
          end

          def duration
            mm, ss = duration_seconds.divmod(60)
            "#{mm}:#{ss.to_s.rjust(2, '0')}"
          end

          def end_reason
            ending = plays.reverse_each.detect {|pl| !pl.timeout? && pl.play_type != 'penalty' }&.parsed_ending
            last_play = plays.reverse_each.detect {|pl| !pl.timeout? }
            ending ||= if last_play.down == 4 && last_play.yards < last_play.yfd
              'Downs'
            else
              'UNKNOWN'
            end
          end

          def first_downs
            plays.count(&:made_first_down?)
          end

          def over?
            (end_reason != 'UNKNOWN') || (overtime? && ['End of Quarter', 'End of Game'].include?(plays.last&.description))
          end

          def handle_plays_and_events(data, **opts)
            create_data(@plays_hash,  data['actions'],  klass: Play,  api: api, drive: self) if data['actions']
            create_data(@events_hash, data['events'],   klass: Event, api: api, drive: self) if data['events']
          end

          def play_count
            plays.count(&:counted_play?)
          end

          def gain
            Array(plays.select(&:counted_play?)).map(&:yards).inject(:+).to_i
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
