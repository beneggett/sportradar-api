module Sportradar
  module Api
    class Nfl::StatPack < Data
      attr_accessor :response, :player, :players, :name, :id, :position

      def initialize(data)
        @response          = data
        set_stats(response)
        set_players
        @player = Sportradar::Api::Nfl::Player.new(response) if response['name']
      end

      def set_players
        if response["player"]
          if response["player"].is_a? Hash
            @players = [ self.class.new(response["player"]) ]
          else
            @players = response["player"].map{ |hash| self.class.new(hash) }
          end
        end
      end

    end
  end
end