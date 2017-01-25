require 'dotenv'
Dotenv.load

require 'simplecov'
require 'coveralls'
require 'codeclimate-test-reporter'
require 'pry'

SimpleCov.formatters = [
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]

SimpleCov.start do
  skip_token 'skip_test_coverage'
end
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

def good_date
  Date.parse('2016-07-17')
end

def old_date
  Date.parse('1950-07-17')
end

VCR.configure do |c|
  c.default_cassette_options = { record: ENV["RECORD"] ? ENV["RECORD"].to_sym : :new_episodes, match_requests_on: [:query], erb: true }
  c.cassette_library_dir = "test/vcr/cassettes"
  c.hook_into :webmock
  c.ignore_hosts 'codeclimate.com'
  c.filter_sensitive_data('<CRICKET_API_KEY>')  { api_key(:cricket ) }
  c.filter_sensitive_data('<ESPORTS_CSGO_API_KEY>')  { api_key(:esports_csgo ) }
  c.filter_sensitive_data('<GOLF_API_KEY>')  { api_key(:golf ) }
  c.filter_sensitive_data('<MLB_API_KEY>')  { api_key(:mlb ) }
  c.filter_sensitive_data('<MMA_API_KEY>')  { api_key(:mma ) }
  c.filter_sensitive_data('<NASCAR_API_KEY>')  { api_key(:nascar ) }
  c.filter_sensitive_data('<NBA_API_KEY>')  { api_key(:nba ) }
  c.filter_sensitive_data('<NCAAF_API_KEY>')  { api_key(:ncaaf ) }
  c.filter_sensitive_data('<NCAAMB_API_KEY>')  { api_key(:ncaamb ) }
  c.filter_sensitive_data('<NCAAWB_API_KEY>')  { api_key(:ncaawb ) }
  c.filter_sensitive_data('<NFL_API_KEY>')  { api_key(:nfl ) }
  c.filter_sensitive_data('<NHL_API_KEY>')  { api_key(:nhl ) }
  c.filter_sensitive_data('<NPB_API_KEY>')  { api_key(:npb ) }
  c.filter_sensitive_data('<RUGBY_API_KEY>')  { api_key(:rugby ) }
  c.filter_sensitive_data('<SOCCER_AFRICA_API_KEY>')  { api_key(:soccer_africa ) }
  c.filter_sensitive_data('<SOCCER_ASIA_API_KEY>')  { api_key(:soccer_asia ) }
  c.filter_sensitive_data('<SOCCER_EUROPE_API_KEY>')  { api_key(:soccer_europe ) }
  c.filter_sensitive_data('<SOCCER_NA_API_KEY>')  { api_key(:soccer_na ) }
  c.filter_sensitive_data('<SOCCER_SA_API_KEY>')  { api_key(:soccer_sa ) }
  c.filter_sensitive_data('<SOCCER_WC_API_KEY>')  { api_key(:soccer_wc ) }
  c.filter_sensitive_data('<TENNIS_API_KEY>')  { api_key(:tennis ) }
  c.filter_sensitive_data('<WNBA_API_KEY>')  { api_key(:wnba ) }
  c.filter_sensitive_data('<IMAGES_NFL_API_KEY>')  { api_key(:images_nfl) }
  c.filter_sensitive_data('<IMAGES_NBA_API_KEY>')  { api_key(:images_nba) }
  c.filter_sensitive_data('<IMAGES_MLS_API_KEY>')  { api_key(:images_mls) }
  c.filter_sensitive_data('<IMAGES_EPL_API_KEY>')  { api_key(:images_epl) }
  c.filter_sensitive_data('<LIVE_IMAGES_NFL_API_KEY>')  { api_key(:live_images_nfl ) }
  c.filter_sensitive_data('<LIVE_IMAGES_NBA_API_KEY>')  { api_key(:live_images_nba ) }
  c.filter_sensitive_data('<LIVE_IMAGES_MLS_API_KEY>')  { api_key(:live_images_mls ) }
  c.filter_sensitive_data('<CONTENT_NBA_V2_API_KEY>')  { api_key(:content_nba_v2 ) }
  c.filter_sensitive_data('<CONTENT_NFL_V2_API_KEY>')  { api_key(:content_nfl_v2 ) }
  c.filter_sensitive_data('<CONTENT_NBA_API_KEY>')  { api_key(:content_nba ) }
  c.filter_sensitive_data('<CONTENT_NFL_API_KEY>')  { api_key(:content_nfl ) }
  c.filter_sensitive_data('<ODDS_API_KEY>')  { api_key(:odds ) }
  c.filter_sensitive_data('<NBA_PRODUCTION>') {api_key(:nba_production) }
  c.filter_sensitive_data('<SOCCER_NA_PRODUCTION') {api_key(:soccer_na_production) }
  c.filter_sensitive_data('<NFL_PRODUCTION') {api_key(:nfl_production) }
  c.filter_sensitive_data('<IMAGES_NFL_PRODUCTION') {api_key(:images_nfl_production) }
  c.filter_sensitive_data('<IMAGES_MLS_PRODUCTION') {api_key(:images_mls_production) }
  c.filter_sensitive_data('<LIVE_IMAGES_NFL_PRODUCTION') {api_key(:live_images_nfl_production) }
  c.filter_sensitive_data('<LIVE_IMAGES_MLS_PRODUCTION') {api_key(:live_images_mls_production) }
  c.filter_sensitive_data('<CONTENT_NFL_PRODUCTION') {api_key(:content_nfl_production) }


end
