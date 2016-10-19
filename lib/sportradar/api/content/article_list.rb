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
        @articles = parse_into_array(selector: response["item"], klass: Sportradar::Api::Content::Article)
      end

    end
  end
end
