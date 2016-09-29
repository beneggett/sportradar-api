module Sportradar
  module Api
    class Error
      class AuthenticationError < StandardError; end
      class NoApiKey < AuthenticationError; end
      class InvalidResponseFormat < TypeError; end
      class InvalidAccessLevel < StandardError; end
      class InvalidLeague < StandardError; end
      class InvalidSeason < StandardError; end
      class InvalidSport < StandardError; end
      class InvalidType < StandardError; end
      class Timeout < Timeout::Error ; end
      class NoData < EOFError; end

      attr_reader :message, :code, :response

      def initialize( code, message, response)
        @code = code
        @message = message
        @response = response
      end

      def success?
        false
      end
    end
  end
end

