module Sportradar
  module Api
    module Baseball
      class Event < Data
        attr_accessor :response, :id, :at_bat, :lineup, :warming_up, :half_inning
        # alias :type :event_type

        def initialize(hash, **opts)
          @response = hash
          @half_inning = opts[:half_inning]
          @at_bat     = AtBat.new(hash['at_bat'],         event: self) if hash['at_bat']
          @lineup     = Lineup.new(hash['lineup'],        event: self) if hash['lineup']
          @warming_up = WarmingUp.new(hash['warming_up'], event: self) if hash['warming_up']
        end

        def description
          (@at_bat || @lineup || @warming_up)&.description
        end

        # def self.new(data, **opts)
        #   klass = subclass(data.keys.first)
        #   klass.new(data, **opts)
        # rescue => e
        #   binding.pry
        # end

        # def ==(other)
        #   @at_bat == other.at_bat && @warming_up == other.warming_up && @lineup == other.lineup
        # end
        def self.subclass(event_type)
          subclasses[event_type]
        end
        def self.subclasses
          @subclasses ||= {
            'at_bat'      => AtBat,
            'lineup'      => Lineup,
            'warming_up'  => WarmingUp,
          }.freeze
        end

      end
    end
  end
end
