# Sportradar Football

![API Reference](https://developer.sportradar.com/files/indexFootball.html)

## NFL

Get started with official NFL api v1:

```ruby
nfl = Sportradar::Api::Football::Nfl.new
nfl = Sportradar::Api::Football::Nfl.new(year: 2016)
res = nfl.get_schedule          # => res is the raw response data hash. the `nfl` object now has weeks present to interact with
res = nfl.get_weekly_schedule   # => res is the raw response data hash. the `nfl` object now has weeks present to interact with
nfl.weeks.count                 # => 17
nfl.games.count                 # => 256
nfl.weeks.first.games.count     # => 16
game = nfl.games.sample         # => Sportradar::Api::Football::Nfl::Game
res = game.get_pbp              # => res is raw response data hash. the `game` object now has quarters/drives/plays to interact with
game.quarters.size              # => 4 (unless the game went to overtime)
game.drives.size                # => (20-30) most NFL games have between 20 and 30 drives
game.plays.size                 # => 150 most NFL games have about 150 total plays

game.get_statistics             # => res is raw response data hash. the `game` object now has team stats to interact with
game.home.stats.passing         # => Sportradar::Api::Football::StatPack::Passing => passing stats
game.home.stats.passing.players.first
```
