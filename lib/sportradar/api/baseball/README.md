# Sportradar Baseball

![API Reference](http://developer.sportradar.com/files/MLBv6SVG.svg)

*Currently, only MLB is supported.*

## MLB

Get started with official MLB api v6:

```ruby
mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
res = mlb.get_daily_summary # => res is the raw response from Sportradar. `mlb` now has game summaries to interact with
res = mlb.get_hierarchy     # => res is the raw response from Sportradar. `mlb` now has leagues/divisions/teams to interact with
mlb.leagues.count           # => 2
mlb.divisions.count         # => 6
mlb.teams.count             # => 30
res = mlb.get_schedule      # => res is the raw response from Sportradar. `mlb` now has games to interact with
mlb.games.count             # => 2430 

game = mlb.games.sample     # => Sportradar::Api::Baseball::Game
data = game.get_pbp         # => data is raw response from Sportradar. `game` now has innings/half innings/atbats/pitches to interact with
game.innings.count          # => 10 (Sportradar has an inning #0, representing starting lineups)
game.half_innings.count     # => 20 (if the game went the full 9 innings)
data = game.get_summary     # => data is raw response from Sportradar. `game` now statistical information to interact with
game.count                  # `count` contains information about the current game state, such as balls/strikes to current batter, current inning, and outs
```

