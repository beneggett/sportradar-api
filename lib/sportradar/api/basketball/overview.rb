module Sportradar
  module Api
    module Basketball
      class Overview < Data
        attr_accessor :game, :home_id, :away_id, :clock, :quarter, :status, :home, :away, :scoring, :venue, :scheduled, :broadcast

        def initialize(game)
          # @game       = game
          @id         = game.id
          @score      = game.score
          @home_id    = game.home_id
          @away_id    = game.away_id
          @home_full  = game.home.full_name
          @away_full  = game.away.full_name
          @team_ids   = game.instance_variable_get(:@team_ids)
          @status     = game.status
          @clock      = game.clock
          @quarter    = game.quarter.to_i
          @broadcast  = game.broadcast
          @scheduled  = game.scheduled
          @timeouts   = game.timeouts
          @scoring    = game.scoring
          @duration   = game.duration
          @attendance = game.attendance

          @venue = OpenStruct.new(name: game.venue.name, city: game.venue.city, location: game.venue.location)
          @home = OpenStruct.new(id: game.home.id, alias: game.home.alias, name: game.home.name, full_name: game.home.full_name)
          @away = OpenStruct.new(id: game.away.id, alias: game.away.alias, name: game.away.name, full_name: game.away.full_name)
        rescue => e
          binding.pry
        end

        def points(team_id)
          team_id.is_a?(Symbol) ? @score[@team_ids[team_id]].to_i : @score[team_id].to_i
        end

        def scoring(quarter)
          @scoring
        end

        # status helpers
        def future?
          ['scheduled', 'delayed'].include? status
        end
        def started?
          ['inprogress', 'halftime', 'delayed'].include? status
        end
        def finished?
          ['completed', 'closed'].include? status
        end
        def closed?
          'closed' == status
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

