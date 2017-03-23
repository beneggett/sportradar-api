module Sportradar
  module Api
    module Baseball
      class HalfInning < Data
        attr_accessor :response, :id, :inning, :type

        def initialize(data, **opts)
          # @response = data
          @api      = opts[:api]
          # @inning   = opts[:inning]

          @id       = data["id"]

          @at_bats_hash = {}

          update(data)
        end
        def update(data, **opts)
          @half     = data['half']
          @events   = data['events'] # contains at-bats, lineup changes, who knows what else
          # create_data(@at_bats_hash, data.dig('at_bats'), klass: AtBat, api: @api, half_inning: self)
        end

        def at_bats
          @at_bats_hash.values
        end

      end
    end
  end
end
