module Sportradar
  module Api
    module Football
      class StatPack < Data
        attr_accessor :response, :player, :name, :id, :position, :yards, :players

        def initialize(data)
          if data['name']
            @response = data
            @player = Sportradar::Api::Nfl::Player.new(data) # need to handle ncaa/nfl, although it may not matter
          else
            @response = data['team'] || data['totals'] || data['kicks']
            @players = parse_into_array(selector: data["players"], klass: self.class) if data["players"]
          end
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
