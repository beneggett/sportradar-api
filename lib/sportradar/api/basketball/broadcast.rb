module Sportradar
  module Api
    module Basketball
      class Broadcast < Data
        attr_accessor :response, :network

        def initialize(data)
          @response = data
          @network = data["network"]
        end

      end
    end
  end
end
