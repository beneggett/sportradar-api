module Sportradar
  module Api
    module Basketball
      class Nba
        class Overview < Basketball::Overview
          attr_accessor :response, :api, :id, :game, :home, :away

          # def initialize(game: )
          #   @game = game
          # end

          # def points(team_id)
          #   team_id.is_a?(Symbol) ? @score[@team_ids[team_id]] : @score[team_id]
          # end
          # def set_score(score)
          #   @score.merge!(score)
          # end

          # def update(data, **opts)

          #   @score  = {  }

          #   @status       = data['status']        if data['status']
          #   @coverage     = data['coverage']      if data['coverage']
          #   @home_team    = data['home_team']     if data['home_team'] # GUID
          #   @away_team    = data['away_team']     if data['away_team'] # GUID
          #   @team_ids     = { home: @home_team, away: @away_team}
          #   @scheduled    = Time.parse(data["scheduled"]) if data["scheduled"]
          #   @venue        = data['venue']         if data['venue']
          #   # @home         = Team.new(data['home'], api: api, game: self) if data['home']
          #   # @away         = Team.new(data['away'], api: api, game: self) if data['away']
          #   @broadcast    = data['broadcast']
          #   @duration     = data['duration']      if data['duration']
          #   @clock        = data['clock']         if data['clock']
          #   @attendance   = data['attendance']    if data['attendance']
          #   @lead_changes = data['lead_changes']  if data['lead_changes']
          #   @times_tied   = data['times_tied']    if data['times_tied']
          #   @scoring      = data['scoring']       if data['scoring']

          # end

          # def path_base
          #   "games/#{ id }"
          # end

        end
      end
    end
  end
end

__END__

ss = sr.schedule;
sr = Sportradar::Api::Basketball::Nba.new
sd = sr.daily_schedule;
g = sd.games.last;
box = g.get_box;
pbp = g.get_pbp;
g.quarters.size
g.plays.size

Sportradar::Api::Basketball::Nba::Team.all.size # => 32 - includes all star teams

