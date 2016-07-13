require 'dotenv'
Dotenv.load

require 'simplecov'
require 'coveralls'
require 'pry'

SimpleCov.start
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sportradar/api'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/focus'
require 'webmock/minitest'
require 'vcr'

def api_key(api)
  ENV.fetch("SPORTRADAR_#{api.to_s.upcase}") {'VALID_SPORTRADAR_API_KEY'}
end

VCR.configure do |c|
  c.default_cassette_options = { record: ENV["RECORD"] ? ENV["RECORD"].to_sym : :new_episodes, match_requests_on: [:query], erb: true }
  c.cassette_library_dir = "test/vcr/cassettes"
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
  c.filter_sensitive_data('<API_KEY>')  { api_key(:cricket ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:esports_csgo ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:golf ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:mlb ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:mma ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:nascar ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:nba ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:ncaaf ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:ncaamb ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:ncaawb ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:nfl ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:nhl ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:npb ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:rugby ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_africa ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_asia ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_europe ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_na ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_sa ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:soccer_wc ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:tennis ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:wnba ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:images_nfl ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:images_nba ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:images_mls ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:live_images_nfl ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:live_images_nba ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:live_images_mls ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:content_nba_v2 ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:content_nfl_v2 ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:content_nba ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:content_nfl ) }
  c.filter_sensitive_data('<API_KEY>')  { api_key(:odds ) }
end
