module Sportradar
  module Api
    module Football
      class Situation < Data
        attr_accessor :response, :clock, :down, :yfd, :possession, :location, :team_id

        def initialize(data)
          @response   = data
          @clock      = data["clock"]
          @down       = data["down"]
          @yfd        = data["yfd"]
          @possession = OpenStruct.new(data["possession"]) if data["possession"]
          if data["location"]
            @location = OpenStruct.new(data["location"])
          elsif data['side'] && data['yard_line']
            @location = OpenStruct.new(alias: data['side'], yardline: data['yard_line'])
          end
          @team_id    = possession&.id || data["team"]
        end

        def spot
          [location&.alias, location&.yardline].compact.join(' ')
        end

        def down_distance
          [@down, @distance].compact.join(' & ')
        end

      end
    end
  end
end
