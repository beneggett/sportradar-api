module Sportradar
  module Api
    module Football
      class Nfl
        class TeamDepthChart < Data
          include Enumerable
          attr_accessor :response, :season, :team_id, :abbrev
          alias :id :team_id

          # data.keys => ["offense", "defense", "special_teams", "name", "market", "alias", "id"]
          def initialize(data, **opts)
            @response = data
            @team_id  = data['id']
            @abbrev   = data['alias']
          end

          def offense
            @offense ||= DepthChart.new(response['offense']) if response['offense']
          end

          def defense
            @defense ||= DepthChart.new(response['defense']) if response['defense']
          end

          def special_teams
            @special_teams ||= DepthChart.new(response['special_teams']) if response['special_teams']
          end

          def each
            [:offense, :defense, :special_teams].each { |type| yield type, send(type) }
          end

          # These aren't ever used, but handy if you need to invoke for testing
          # private

          # def set_charts
          #   [offense, defense, special_teams]
          # end

        end
      end
    end
  end
end