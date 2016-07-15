[![Gem Version](https://badge.fury.io/rb/sportradar-api.svg)](https://badge.fury.io/rb/sportradar-api)
[![Build Status](https://travis-ci.org/beneggett/sportradar-api.svg?branch=master)](https://travis-ci.org/beneggett/sportradar-api)
[![Code Climate](https://codeclimate.com/github/beneggett/sportradar-api/badges/gpa.svg)](https://codeclimate.com/github/beneggett/sportradar-api)
[![Coverage Status](https://coveralls.io/repos/github/beneggett/sportradar-api/badge.svg?branch=master)](https://coveralls.io/github/beneggett/sportradar-api?branch=master)


# Sportradar API

The SportRadar API extensively covers league & sports data. This gem wraps it up, marshals the data into Ruby Objects we know and love.


Currently (July 2016) the SportRadar API has 23 documented APIs.

Our goal is to incrementally integrate with them. **Contributions are welcome**

## SportRadar APIs

[Current API Versions](http://developer.sportradar.us/api_gallery)

| API | Version | Docs | Implemented? | Priority |
| --- | --- | --- | --- | --- |
| NFL | 1 | [📚](http://developer.sportradar.us/page/NFL_Official) | - | 👍 |
| MLB | 5 | [📚](http://developer.sportradar.us/docs/MLB_API) | - | - |
| NHL | 3 | [📚](http://developer.sportradar.us/docs/NHL_API) | - | - |
| NBA | 3 | [📚](http://developer.sportradar.us/docs/NBA_API) | - | - |
| NCAAMB  | 3 | [📚](http://developer.sportradar.us/docs/NCAA_Mens_Basketball) | - | - |
| NCAAFB  | 1 | [📚](http://developer.sportradar.us/docs/NCAA_Football_API) | - | - |
| Golf  | 2 | [📚](http://developer.sportradar.us/docs/Golf_API) | - | - |
| NASCAR  | 3 | [📚](http://developer.sportradar.us/page/NASCAR_Official) | - | - |
| Odds  | 1 | [📚](http://developer.sportradar.us/docs/Odds_API) | - | 👍 |
| Content | 3 | [📚](http://developer.sportradar.us/docs/Content_API) | - | 👍 |
| Images  | 2 | [📚](http://developer.sportradar.us/docs/Images_API) | - | 👍 |
| Live Images | 1 | [📚](http://developer.sportradar.us/docs/Live_Images_API) | - | 👍 |
| Olympics  | 2 | [📚](http://developer.sportradar.us/docs/Olympics_API_v2) | - | - |
| Soccer  | 2 | [📚](http://developer.sportradar.us/docs/Soccer_API) | - | 👍 |
| NCAAWB  | 3 | [📚](http://developer.sportradar.us/docs/read/NCAA_Womens_Basketball) | - | - |
| MMA | 1 | [📚](http://developer.sportradar.us/docs/MMA_API) | - | - |
| Cricket   | 1 | [📚](http://developer.sportradar.us/docs/cricket_API) | - | - |
| WNBA  | 3 | [📚](http://developer.sportradar.us/docs/WNBA_API) | - | - |
| NCAAMH  | 3 | [📚](http://developer.sportradar.us/docs/read/NCAA_Mens_Hockey) | - | - |
| NPB | 1 | [📚](http://developer.sportradar.us/docs/NPB_API) | - | - |
| Rugby | 1 | [📚](http://developer.sportradar.us/docs/Rugby_API) | - | - |
| Tennis  | 1 | [📚](http://developer.sportradar.us/docs/Tennis_API) | - | - |
| ESPORTS | 1 | [📚](http://developer.sportradar.us/docs/ESPORTS_API) | - | - |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sportradar-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sportradar-api

## Usage

### Configuration

Manage your ruby environment through `.ruby-version` and `.ruby-gemset` files.

Create `.env` for environment variables. Follow the `.env.sample` for guidance.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beneggett/sportradar-api.

