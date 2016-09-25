module Sportradar
  module Api
    class Content::ArticleList < Data
      attr_accessor :response, :provider, :sport, :start_time, :end_time, :articles

      def initialize(data)
        @response = data
        @sport = data["sport"]
        @provider = data["provider"]
        @start_time = Time.parse(data["start_time"]) if data["start_time"]
        @end_time = Time.parse(data["end_time"]) if data["end_time"]
        set_articles
      end

      private
      def set_articles
        if response["item"]
          if response["item"].is_a?(Array)
            @articles = response["item"].map {|x| Sportradar::Api::Content::Article.new x }
          elsif response["item"].is_a?(Hash)
            @articles = [ Sportradar::Api::Content::Article.new(response["item"]) ]
          end
        end
      end

    end
  end
end
