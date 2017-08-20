module Sportradar
  module Api
    module Football
      class Nfl
        class DepthChart < Data
          include Enumerable
          attr_accessor :response, :chart

          def initialize(data)
            generate_chart(data)
          end

          def team(number)
            teams[number]
          end

          def each
            populate_teams
            teams.each { |team| yield team }
          end

          private

          def teams
            @teams ||= populate_teams
          end

          def populate_teams
            (1..3).each_with_object({}) do |i, hash|
              hash[i] = generate_team(i)
            end
          end

          def generate_team(number)
            @chart.each_with_object({}) do |(pos_name, groups), memo|
              memo[pos_name] = groups[number]
            end
          end

          def generate_chart(data)
            @chart = data.each_with_object({}) do |hash, memo|
              position = hash['position']
              players = position['players'].map { |h| Sportradar::Api::Football::Nfl::Player.new(h) }
              memo[position['name']] = players.group_by(&:depth)
              # binding.pry
            end
          end

        end
      end
    end
  end
end
