module Sportradar
  module Api
    class Soccer::Tournament < Data
      attr_accessor :response, :id, :name, :season_start, :season_end, :season, :type, :reference_id, :coverage, :teams

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @season_start = data["season_start"]
        @season_end = data["season_end"]
        @season = data["season"]
        @reference_id = data["reference_id"]
        @coverage = OpenStruct.new data["coverage"] if data["coverage"]
        @teams = parse_into_array(selector: response["team"], klass: Sportradar::Api::Soccer::Team)  if response["team"]
      end

    end
  end
end
