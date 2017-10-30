module Sportradar
  module Api
    module Soccer
      class Lineup < Data
        attr_reader :id, :team, :manager, :jersey, :starting_lineup, :substitutes

        def initialize(data, **opts)
          @response     = data
          @id           = data["team"]

          @starting_hash  = {}
          @subs_hash      = {}

          update(data, **opts)
        end
        def update(data, **opts)
          @team     = data['team']                    if data['team']
          @manager  = OpenStruct.new(data['manager']) if data['manager']
          @jersey   = OpenStruct.new(data['jersey'])  if data['jersey']
          # @starting_lineup  = data['starting_lineup'] if data['starting_lineup']
          # @substitutes      = data['substitutes']     if data['substitutes']

          create_data(@starting_hash, data['starting_lineup'], klass: Player, api: opts[:api], lineup: self) if data['starting_lineup']
          create_data(@subs_hash,     data['substitutes'],     klass: Player, api: opts[:api], lineup: self) if data['substitutes']
        end

      end

    end
  end
end
