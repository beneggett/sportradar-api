module Sportradar
  module Api
    class Images::Asset < Data
      attr_accessor :response, :id, :player_id, :created, :updated, :title, :description, :copyright, :links, :tags

      def initialize(data)
        @response = data
        @id = data["id"]
        @player_id = data["player_id"]
        @created = data["created"]
        @updated = data["updated"]
        @title = data["title"]
        @description = data["description"]
        @copyright = data["copyright"]
        @links = parse_into_array(selector: response.dig("links", "link"), klass: Sportradar::Api::Images::Link)
        @tags = parse_into_array(selector: response.dig("tags", "tag"), klass: Sportradar::Api::Images::Tag)
      end

    end
  end
end
