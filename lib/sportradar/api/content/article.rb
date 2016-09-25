module Sportradar
  module Api
    class Content::Article < Data
      attr_accessor :response, :type, :created, :updated, :injury, :transaction, :title, :byline, :dateline, :credit, :content, :references, :provider

      def initialize(data)
        @response = data
        @created = Time.parse(data["created"]) if data["created"]
        @updated = Time.parse(data["updated"]) if data["updated"]
        @type = data["type"]
        @injury = data["injury"]
        @transaction = data["transaction"]
        @title = data["title"]
        @byline = data["byline"]
        @dateline = data["dateline"]
        @credit = data["credit"]
        @content = data["content"]["long"] if data["content"] && data["content"]["long"]
        @provider = OpenStruct.new(data["provider"]) if data["provider"]
        set_references
      end

      def transaction?
        !!transaction
      end

      def injury?
        !!injury
      end
      private
      def set_references
        if response["refs"] && response["refs"]["ref"]
          if response["refs"]["ref"].is_a?(Array)
            @references = response["refs"]["ref"].map {|x| Sportradar::Api::Content::Reference.new x }
          elsif response["refs"]["ref"].is_a?(Hash)
            @references = [ Sportradar::Api::Content::Reference.new(response["refs"]["ref"]) ]
          end
        end
      end

    end
  end
end
