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
        @tournament_groups = parse_into_array(selector: response["tournament_group"], klass: Sportradar::Api::Soccer::TournamentGroup)  if response["tournament_group"]
      end

    end
  end
end
