module Sportradar
  module Api
    class << self
      attr_accessor :config
    end

    def self.config
      @config ||= Config.new
    end

    # Set options via block
    def self.configure
      yield(config) if block_given?
    end

    class Config
      attr_accessor :api_key, :api_timeout, :use_ssl, :format

      def initialize
        @api_key = ENV['API_KEY']
        @api_timeout = ENV.fetch('SPORTRADAR_API_TIMEOUT', 15 )
        @use_ssl = ENV.fetch('SPORTRADAR_API_USE_SSL', true)
        @format = ENV.fetch("SPORTRADAR_API_FORMAT", :xml).to_s
      end

      def reset
        self.api_key = ENV['API_KEY']
        self.api_timeout = ENV.fetch('SPORTRADAR_API_TIMEOUT', 15 )
        self.use_ssl = ENV.fetch('SPORTRADAR_API_USE_SSL', true)
        self.format = ENV.fetch("SPORTRADAR_API_FORMAT", :xml).to_s
      end
    end
  end
end

