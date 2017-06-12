module Sportradar
  module Api
    module Football
      class Week < Data
        attr_accessor :response, :id, :number, :api, :hierarchy, :year, :type

        def all_attributes
          [:number]
        end

        def initialize(data = {}, **opts)
          # @response = data
          @api        = opts[:api]
          @id         = data['id']
          @hierarchy  = opts[:hierarchy]

          @games_hash = {}

          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          # update stuff
          @year = opts[:hierarchy].season_year    if opts[:hierarchy]
          @type = opts[:hierarchy].ncaafb_season  if opts[:hierarchy]

          @number = data['number']  if data['number']

          create_data(@games_hash, data['games'],   klass: game_class,   week: self, api: api)
        end

        def games
          @games_hash.values
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

ncaafb = Sportradar::Api::Football::Ncaafb::Hierarchy.new
gg = ncaafb.games;
g = gg.first;
g.week
g.week_number
g.year
g.type
