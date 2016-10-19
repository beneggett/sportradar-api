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
        @references = parse_into_array(selector: response.dig("refs","ref"), klass: Sportradar::Api::Content::Reference)
      end

      def transaction?
        transaction == 'true'
      end

      def injury?
        injury == 'true'
      end

    end
  end
end
