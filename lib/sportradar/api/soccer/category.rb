module Sportradar
  module Api
    class Soccer::Category < Data
      attr_accessor :response, :id, :name, :country_code, :country, :tournament_groups

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @country_code = data["country_code"]
        @country = data["country"]
        set_tournament_group
      end

      private
      def set_tournament_group
        if response["tournament_group"]
          if response["tournament_group"].is_a?(Array)
            @tournament_groups = response["tournament_group"].map {|x| Sportradar::Api::Soccer::TournamentGroup.new x }
          elsif response["tournament_group"].is_a?(Hash)
            @tournament_groups = [ Sportradar::Api::Soccer::TournamentGroup.new(response["tournament_group"]) ]
          end
        end
      end

    end
  end
end
