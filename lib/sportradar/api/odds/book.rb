module Sportradar
  module Api
    module Odds
      class Book < Data
        attr_accessor :response, :id, :name


        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @id       = data['id']
          @name     = data['name']
        end

        def update(data, **opts)

        end

      end
    end
  end
end
