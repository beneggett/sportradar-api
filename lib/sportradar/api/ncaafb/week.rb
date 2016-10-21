module Sportradar
  module Api
    class Ncaafb::Week < Data
      attr_accessor :response, :id, :sequence, :title

      def initialize(data)
        @response = data
        @id       = response['id']
        @year     = response['year']
        @type     = response['type']
        @name     = response['name']
        @sequence = response['sequence']
      end

      # private

      def games
        @game ||= if response["game"]
          if response["game"].is_a?(Array)
            @games = response["game"].map {|game| Sportradar::Api::Ncaafb::Game.new game }
          elsif response["game"].is_a?(Hash)
            @games = [ Sportradar::Api::Ncaafb::Game.new(response["game"]) ]
          end
        end
      end

    end
  end
end
