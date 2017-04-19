module Sportradar
  module Api
    module Baseball
      class Event < Data
        attr_accessor :response, :id, :at_bat, :lineup, :warming_up
        # alias :type :event_type

        def initialize(hash, **opts)
          @at_bat     = AtBat.new(hash['at_bat'])         if hash['at_bat']
          @lineup     = Lineup.new(hash['lineup'])        if hash['lineup']
          @warming_up = WarmingUp.new(hash['warming_up']) if hash['warming_up']
        end

        # def self.new(data, **opts)
        #   klass = subclass(data.keys.first)
        #   klass.new(data, **opts)
        # rescue => e
        #   binding.pry
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
