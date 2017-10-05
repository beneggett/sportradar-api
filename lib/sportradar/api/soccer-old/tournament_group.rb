module Sportradar
  module Api
    class Soccer::TournamentGroup < Data
      attr_accessor :response, :id, :name, :season_start, :season_end, :season, :reference_id, :top_goals, :top_own_goals, :top_assists, :top_cards, :top_points, :tournaments

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @season_start = data["season_start"]
        @season_end = data["season_end"]
        @season = data["season"]
        @reference_id = data["reference_id"]
        @top_goals = parse_players(data["top_goals"]["player"]) if data["top_goals"] && data["top_goals"]["player"]
        @top_own_goals = parse_players(data["top_own_goals"]["player"]) if data["top_own_goals"] && data["top_own_goals"]["player"]
        @top_assists = parse_players(data["top_assists"]["player"]) if data["top_assists"] && data["top_assists"]["player"]
        @top_cards = parse_players(data["top_cards"]["player"]) if data["top_cards"] && data["top_cards"]["player"]
        @top_points = parse_players(data["top_points"]["player"]) if data["top_points"] && data["top_points"]["player"]
        @tournaments = parse_into_array(selector: response["tournament"], klass: Sportradar::Api::Soccer::Tournament)  if response["tournament"]
      end

      private

      def parse_players(field_to_parse)
        if field_to_parse.is_a?(Array)
          field_to_parse.map {|player| Sportradar::Api::Soccer::Player.new player }
        elsif field_to_parse.is_a?(Hash)
          [ Sportradar::Api::Soccer::Player.new(field_to_parse) ]
        end
      end


    end
  end
end
