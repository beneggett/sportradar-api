require "rubygems"

require "httparty"

require "sportradar/api/version"

require "sportradar/api/config"
require "sportradar/api/error"
require "sportradar/api/request"

require "sportradar/api/soccer"
require "sportradar/api/nfl"
require "sportradar/api/images"
require "sportradar/api/live_images"

module Sportradar
  module Api

    API_GALLERY = [
        {api: :nfl, version:  1},
        {api: :mlb, version:  5},
        {api: :nhl, version:  3},
        {api: :nba, version:  3},
        {api: :ncaamb, version:   3},
        {api: :ncaafb, version:   1},
        {api: :golf, version:   2},
        {api: :nascar, version:   3},
        {api: :odds, version:   1},
        {api: :content, version:  3},
        {api: :images, version:   2},
        {api: :live_images, version:  1},
        {api: :olympics, version:   2},
        {api: :soccer, version:   2},
        {api: :ncaawb, version:   3},
        {api: :mma, version:  1},
        {api: :cricket, version:    1},
        {api: :wnba, version:   3},
        {api: :ncaamh, version:   3},
        {api: :npb, version:  1},
        {api: :rugby, version:  1},
        {api: :tennis, version:   1},
        {api: :esports, version:  1}
      ]


    private

    def self.api_key_params(api)
      { api_key: self.api_key(api) }
    end

    def self.api_key(api)
      ENV.fetch("SPORTRADAR_#{api.to_s.upcase.gsub('-', '_')}", "api_key missing for #{api}")
    end

    def self.version(api)
      find_api = API_GALLERY.find{ |x| x[:api] == api.downcase.to_sym }
      !find_api.nil? ? find_api[:version] : "version missing for #{api}"
    end

  end
end
