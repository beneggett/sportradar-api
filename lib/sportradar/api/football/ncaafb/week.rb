module Sportradar
  module Api
    module Football
      class Ncaafb
        class Week < Sportradar::Api::Football::Week

          def update(data, source: nil, **opts)
            # update stuff
            @number = data['number']  if data['number']

            create_data(@games_hash, data['games'],   klass: Game,   week: self, api: api)
          end

        end
      end
    end
  end
end

__END__



ncaafb = Sportradar::Api::Football::Ncaafb::Hierarchy.new
ncaafb = Sportradar::Api::Football::Ncaafb::Hierarchy.new
res1 = ncaafb.get_schedule;
res2 = ncaafb.get_weekly_schedule;
