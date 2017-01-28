module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Hierarchy < Data
          attr_accessor :response, :id, :name, :alias
          def all_attributes
            [:name, :alias, :conferences, :divisions, :teams]
          end

          def initialize(data, **opts)
            # @response = data
            @api      = opts[:api]

            @id    = data.dig('league', 'id')
            @name  = data.dig('league', 'name')
            @alias = data.dig('league', 'alias')

            @divisions_hash = create_data({}, data['divisions'], klass: Division, hierarchy: self, api: @api)
          end
          def divisions
            @divisions_hash.values
          end
          def division(code_name)
            divisions_by_name[code_name]
          end
          private def divisions_by_name
            @divisions_by_name ||= divisions.map { |d| [d.alias, d] }.to_h
          end
          def conferences
            divisions.flat_map(&:conferences)
          end
          def teams
            conferences.flat_map(&:teams)
          end

          def api
            @api || Sportradar::Api::Basketball::Ncaamb.new
          end

        end
      end
    end
  end
end

__END__

st = sr.standings;

st = sr.standings;
sr = Sportradar::Api::Basketball::Ncaamb.new;
lh = sr.hierarchy;
div = lh.division('D1');
div.teams.count
div.conferences.count
div.conferences.first;
p12 = div.conference('PAC12');
t = p12.team('ARIZ') # => 'id' => "9b166a3f-e64b-4825-bb6b-92c6f0418263"
t = div.teams.sample
res = t.get_roster;
res = t.get_season_stats;

t = lh.teams.first;
t.venue.id
