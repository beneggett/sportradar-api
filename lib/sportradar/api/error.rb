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

      attr_reader :message, :status_code, :status

      def initialize(response_status, response_code, response_message = nil)
        @status_code = response_code
        @status = response_status
        @message = response_message
      end
    end
  end
end

