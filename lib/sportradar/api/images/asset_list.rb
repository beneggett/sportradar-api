module Sportradar
  module Api
    class Images::AssetList < Data
      attr_accessor :response, :type, :sport, :assets

      def initialize(data)
        @response = data
        @type = data["type"]
        @sport = data["sport"]
        set_assets
      end

      private
      def set_assets
        if response["asset"]
          if response["asset"].is_a?(Array)
            @assets = response["asset"].map {|x| Sportradar::Api::Images::Asset.new x }
          elsif response["asset"].is_a?(Hash)
            @assets = [ Sportradar::Api::Images::Asset.new(response["asset"]) ]
          end
        end
      end

    end
  end
end
