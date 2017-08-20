module Sportradar
  module Api
    module Football
      class Nfl
        class LeagueDepthChart < Data
          include Enumerable
          attr_accessor :response, :week_number, :charts

          def initialize(data, **opts)
            @response = data
            @charts_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @week = data['week']
            @week_number = data.dig('week', 'sequence')
            create_data(@charts_hash, data["teams"], klass: TeamDepthChart, api: opts[:api])

            self
          end

          def charts
            @charts_hash.values
          end

          # id is preferred search, but we allow for team abbreviation too
          def team(id = nil, abbrev: nil)
            charts.detect { |chart| chart.team_id == id || chart.abbrev == abbrev }
          end

          def each
            self.charts.each { |chart| yield chart }
          end

        end
      end
    end
  end
end
