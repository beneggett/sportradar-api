module Sportradar
  module Api
    module Football
      class Ncaafb
        class Game < Sportradar::Api::Football::Game

          def path_base
            "#{ year }/#{ type }/#{ week_number.to_s.rjust(2, '0') }/#{ away_alias }/#{ home_alias }"
          end

          def generate_title
            if home && away
              "#{home.full_name} vs #{away.full_name}"
            elsif home_alias && away_alias
              "#{home_alias} vs #{away_alias}"
            end
          end

          def type
            'REG'
          end


          def get_extended_box
            data = api.get_data(path_extended_box).to_h
            ingest_extended_box(data)
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
