module Sportradar
  module Api
    class Nfl::StatPack < Data
      attr_accessor :response, :avg_yards, :attempts, :touchdowns, :tlost, :tlost_yards, :yards, :longest, :longest_touchdown, :redzone_attempts

      def initialize(data)
        @response          = data
        @players           = data["player"].map { |hash| self.class.new(hash) } if data["player"]
        set_stats
      end

      def data
        @response
      end

      def player_attributes
        "name"
        "jersey"
        "reference"
        "id"
        "position"
      end

    end


  end
end