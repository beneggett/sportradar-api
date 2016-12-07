module Sportradar
  module Api
    module Basketball
      class Profile < Data
        attr_accessor :team, :name

        def initialize(team)
          # @team       = team
          @id         = team.id
          # @score      = team.score
          # @home_id    = team.home_id
          # @away_id    = team.away_id
          # @home_full  = team.home.full_name
          # @away_full  = team.away.full_name
          # @team_ids   = team.instance_variable_get(:@team_ids)
          # @status     = team.status
          # @clock      = team.clock
          # @quarter    = team.quarter.to_i
          # @broadcast  = team.broadcast
          # @scheduled  = team.scheduled
          # @venue_name = team.venue.name
          # @venue_city = team.venue.city
          # @location   = team.venue.location
          # @timeouts   = team.timeouts
          # @scoring    = team.scoring
          # @duration   = team.duration
          # @attendance = team.attendance
        end

      end
    end
  end
end

__END__

ss = sr.schedule;
sr = Sportradar::Api::Nba.new
sd = sr.daily_schedule;
g = sd.games.last;
g.overview
box = g.get_box;
pbp = g.get_pbp;
g.quarters.size
g.plays.size

Sportradar::Api::Nba::Team.all.size # => 32 - includes all star teams

