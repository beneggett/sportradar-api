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

        set_links
        set_tags
      end

      private

      def set_links
        if response["links"] && response["links"]["link"]
          if response["links"]["link"].is_a?(Array)
            @links = response["links"]["link"].map {|x| Sportradar::Api::Images::Link.new x }
          elsif response["links"]["link"].is_a?(Hash)
            @links = [ Sportradar::Api::Images::Link.new(response["links"]["link"]) ]
          end
        end
      end

      def set_tags
        if response["tags"] && response["tags"]["tag"]
          if response["tags"]["tag"].is_a?(Array)
            @tags = response["tags"]["tag"].map {|x| Sportradar::Api::Images::Tag.new x }
          elsif response["tags"]["tag"].is_a?(Hash)
            @tags = [ Sportradar::Api::Images::Tag.new(response["tags"]["tag"]) ]
          end
        end
      end


    end
  end
end
