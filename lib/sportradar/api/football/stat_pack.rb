module Sportradar
  module Api
    module Football
      class StatPack < Data
        attr_accessor :response, :player, :name, :id, :position, :yards, :players

        def initialize(data)
          @response = data || {}
          @player = Sportradar::Api::Nfl::Player.new(response) if response['name'] # this isn't used yet, and we need to determine a better solution
          @players = parse_into_array(selector: response["player"], klass: self.class) if response["player"]
          set_stats
        end

        private

        def set_stats
          raise NotImplementedError, "Please implement `#{self.class}#set_stats`"
        end

      end
    end
  end
end
