module Sportradar
  module Api
    class Content < Request
      attr_accessor :sport, :access_level

      def initialize( sport, access_level = 't')
        raise Sportradar::Api::Error::InvalidSport unless allowed_sports.include? sport
        @sport = sport
        raise Sportradar::Api::Error::InvalidAccessLevel unless allowed_access_levels.include? access_level
        @access_level = access_level
      end

      def news( date = Date.today, content_type = 'all' )
        raise Sportradar::Api::Error::InvalidType unless allowed_news_types.include? content_type
        response = get request_url("#{provider }/news/#{date_path(date)}/#{content_type}")
        Sportradar::Api::Content::ArticleList.new response["content"]  if response.success? && response["content"]
      end

      def analysis( date = Date.today, content_type = 'all' )
        raise Sportradar::Api::Error::InvalidType unless allowed_analysis_types.include? content_type
        response = get request_url("#{provider }/analysis/#{date_path(date)}/#{content_type}")
        Sportradar::Api::Content::ArticleList.new response["content"]  if response.success? && response["content"]
      end

      private

      def request_url(path)
        "/content-#{sport}-#{access_level}#{version}/#{path}"
      end

      def api_key
        if access_level == 'p'
          Sportradar::Api.api_key_params("content_#{sport}", "production")
        else
          Sportradar::Api.api_key_params("content_#{sport}")
        end
      end

      def provider
        'tsx'
      end

      def version
        Sportradar::Api.version('content')
      end

      def allowed_access_levels
        ['p', 't']
      end

      def allowed_sports
        ['nfl', 'ncaafb', 'nhl', 'nba', 'ncaamb', 'mlb', 'golf', 'nascar', 'f1', 'auto-racing']
      end

      def allowed_news_types
        ['all', 'injuries', 'transactions']
      end

      def allowed_analysis_types
        ['all', 'preview', 'recap', 'team_report']
      end

    end
  end
end
