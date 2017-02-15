module Sportradar
  module Api
    module Basketball
      class Nba
        class Hierarchy < Data
          attr_accessor :response, :id, :name, :alias
          def all_attributes
            [:name, :alias, :conferences, :divisions, :teams]
          end

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id = data.dig('league', "id")
            @name = data.dig('league', "name")
            @alias = data.dig('league', "alias")
            @season = Season.new(data['season']) if data['season']
            @conferences_hash = create_data({}, data['conferences'], klass: Conference, hierarchy: self, api: @api)
          end
          def conferences
            @conferences_hash.values
          end
          def divisions
            conferences.flat_map(&:divisions)
          end
          def teams
            divisions.flat_map(&:teams)
          end

          def api
            @api || Sportradar::Api::Basketball::Nba.new
          end

        end
      end
    end
  end
end

__END__

st = sr.standings;
sr = Sportradar::Api::Basketball::Nba.new
lh = sr.league_hierarchy;
t = lh.teams.first;
t.venue.id
