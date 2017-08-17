module Sportradar
  module Api
    module Football
      class Ncaafb
        class Game < Sportradar::Api::Football::Game

          def initialize(data, **opts)
            if data['id'].include?('/')
              @year, @type, @week_number, @away_alias, @home_alias = data.delete('id').split('/')
            end
            super
          end

          def clock_display
            if clock && quarter
              quarter > 4 ? quarter_display : "#{clock} #{quarter_display}"
            end
          end

          def path_base
            "#{ year }/#{ type }/#{ week_number.to_s }/#{ away_alias }/#{ home_alias }"
          end

          def generate_title
            if home.full_name && away.full_name
              "#{home.full_name} vs #{away.full_name}"
            elsif home_alias && away_alias
              "#{home_alias} vs #{away_alias}"
            end
          end

          def type # Bowl games don't seem to work when they use the bowl type instead of REG
            'REG'
          end


          def get_extended_box
            data = api.get_data(path_extended_box).to_h
            ingest_extended_box(data)
          end

          def queue_extended_box
            url, headers, options, timeout = api.get_request_info(path_extended_box)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_extended_box)}
          end

          def ingest_extended_box(data)
            data = data
            update(data, source: :extended_box)
            check_newness(:extended_box, @clock)
            data
          end

          def get_summary
            data = api.get_data(path_summary).to_h
            ingest_summary(data)
          end

          def queue_summary
            url, headers, options, timeout = api.get_request_info(path_summary)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_summary)}
          end

          def ingest_summary(data)
            data = data
            update(data, source: :summary)
            @quarter = data.delete('quarter').to_i
            check_newness(:box, @clock)
            check_newness(:score, @score)
            data
          end

          def ingest_pbp(data)
            super.tap {
              clock = self.plays.last&.clock
              quarter = self.quarters.last&.number
              @clock    = clock   if clock
              @quarter  = quarter if quarter
            }
          end

          def team_class
            Team
          end
          def period_class
            Quarter
          end

          def period_name
            'quarter'
          end

          def quarter_class
            Sportradar::Api::Football::Ncaafb::Quarter
          end


          def api
            @api || Sportradar::Api::Football::Ncaafb::Api.new
          end

        end
      end
    end
  end
end

__END__

File.binwrite('ncaafb.bin', Marshal.dump(ncaafb))

ncaafb = Sportradar::Api::Football::Ncaafb.new(year: 2016)
ncaafb = Sportradar::Api::Football::Ncaafb.new
gg = ncaafb.games;
ncaafb = Marshal.load(File.binread('ncaafb.bin'));
g2 = ncaafb.games.sample
g = gg.first;
g = gg.sample;
g.week_number
g.year
g.type
g.path_pbp
res = g.get_pbp;

ncaafb = Marshal.load(File.binread('ncaafb.bin'));
g = ncaafb.games.first;
res = g.get_pbp;
g.quarters.first.drives[1]

g = gg.detect{|g| g.id == "b8001149-bb55-4014-a3e8-6ac0a261dfe1" } # overtime game
