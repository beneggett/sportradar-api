module Sportradar
  module Api
    class Images::AssetList < Data
      attr_accessor :response, :type, :sport, :assets

      def initialize(data)
        @response = data
        @type = data["type"]
        @sport = data["sport"]
        @assets = parse_into_array(selector: response["asset"], klass: Sportradar::Api::Images::Asset)
      end

    end
  end
end
