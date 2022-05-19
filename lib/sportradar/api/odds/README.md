# Some snippets

```ruby

odds = Sportradar::Api::Odds::PlayerOdds.new
data = odds.get_books
data = odds.get_sports
data = odds.get_event_mappings


sport = odds.sports.first
sport.get_competitions
comp = sport.competitions.first

api = Sportradar::Api::Odds::PlayerOdds.api
comp = Sportradar::Api::Odds::Competition.new({'id' => 'sr:competition:234'}, api: api)
data = comp.get_player_props
comp.sport_events
event = comp.sport_events.first

odds = Sportradar::Api::Odds::PlayerOdds.new
data = odds.get_sports
sport = odds.sports.first
sport.get_competitions
comp = sport.competitions.first

event = comp.sport_events.first
event.player_props
event.response
prop = event.player_props.first
prop.markets.count
market = prop.markets.first
market.response
market.name
bm = market.book_markets.first
outcome = bm.outcomes.first


# {"id"=>"sr:competition:8", "name"=>"LaLiga", "gender"=>"men", "markets"=>true, "futures"=>false, "player_props"=>true, "category"=>{"id"=>"sr:category:32", "name"=>"Spain", "country_code"=>"ESP"}},


```

# Some links

https://api.sportradar.com/oddscomparison-player-props/trial/v2/en/books.xml?api_key=
https://api.sportradar.com/oddscomparison-player-props/trial/v2/en/sports/sr:sport:1/competitions.xml?api_key=
https://api.sportradar.com/oddscomparison-player-props/trial/v2/en/competitions/sr:competition:234/players_props.json?api_key=
https://api.sportradar.com/oddscomparison-player-props/trial/v2/en/sports.xml?api_key=
