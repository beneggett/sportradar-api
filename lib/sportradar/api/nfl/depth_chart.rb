module Sportradar
  module Api
    class Nfl::DepthChart < Data
      attr_accessor :response, :chart

      def initialize(data)
        generate_chart(data)
      end

      def team(number)
        teams[number]
      end

      private

      def teams
        @teams ||= Hash.new { |hash, number| hash[number] = generate_team(number) }
      end

      def generate_team(number)
        @chart.each_with_object({}) do |(pos_name, groups), memo|
          memo[pos_name] = groups[number.to_s]
        end
      end

      def generate_chart(data)
        @chart = data['position'].each_with_object({}) do |position, memo|
          players = position['player'].map { |h| Sportradar::Api::Nfl::Player.new(h) }
          memo[position['name']] = players.group_by(&:depth)
        end
      end

    end
  end
end
