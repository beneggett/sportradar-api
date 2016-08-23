module Sportradar
  module Api
    class Nfl::StatPack < Data
      attr_accessor :response, :player, :name, :id, :position, :yards

      def initialize(data)
        @response = data
        set_stats
        @player = Sportradar::Api::Nfl::Player.new(response) if response['name']
      end

      def players
        @players ||= set_players
      end

      private

      def set_stats
        raise NotImplementedError, "Please implement `#{self.class}#set_stats`"
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