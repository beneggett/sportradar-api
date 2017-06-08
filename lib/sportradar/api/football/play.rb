module Sportradar
  module Api
    module Football
      class Play < Data
        attr_accessor :response, :id, :sequence, :reference, :clock, :home_points, :away_points, :type, :play_clock, :wall_clock, :start_situation, :end_situation, :description, :alt_description, :statistics, :score, :scoring_play, :team_id, :player_id

        def initialize(data, **opts)
          @response          = data
          @id                = data["id"]

          update(data, **opts)
        end

        def update(data, **opts)
          @type              = data["type"]
          @alt_description   = data["alt_description"]
          @away_points       = data["away_points"]
          @clock             = data["clock"]
          @description       = data["description"] || data['summary']
          # @end_situation   = Sportradar::Api::Nfl::Situation.new data["end_situation"] if data["end_situation"]
          @team_id           = end_situation.team_id if end_situation
          @home_points       = data["home_points"]
          @play_clock        = data["play_clock"]
          @reference         = data["reference"]
          @score             = data["score"]
          @scoring_play      = data["scoring_play"]
          @sequence          = data["sequence"]
          # @start_situation = Sportradar::Api::Nfl::Situation.new data["start_situation"] if data["start_situation"]
          # @statistics      = Sportradar::Api::Nfl::PlayStatistics.new data["statistics"] if data["statistics"]
          parse_player if @statistics
          @wall_clock        = data["wall_clock"]

          self
        end

        def parse_player
          # TODO: Currently there is an issue where we are only mapping one player_id to a play, but there are plays with multiple players involved.
          play_stats = @statistics.penalty || @statistics.rush || @statistics.return || @statistics.receive
          if play_stats.is_a?(Array)
            play_stats = play_stats.first
          end
          @player_id = play_stats&.player&.id
        end
      end

    end
  end
end

__END__

ncaafb = Marshal.load(File.binread('ncaafb.bin'));
g = ncaafb.games.first;
res = g.get_pbp;
g.plays.count
g.plays.map(&:type)
g.plays.select {|p| p.type == 'event' }
sr = Sportradar::Api::Nfl.new
sch = sr.schedule(2016)
ls sc
ls sch
sch.weeks.count
sch.weeks.first.class
sch.weeks.first.games.size
sch.weeks.first.games.first
sg = sch.weeks.first.games.first;
sg
pbp = sr.play_play_play(sg.id);
pbp = sr.play_by_play(sg.id);
pbp.events
pbp.drives.size
pbp.drives.flat_map(&:plays)
pbp.drives.flat_map(&:plays).first.response
pbp.drives.flat_map(&:events)
pbp.drives.flat_map(&:plays).map(&:type)
g.drives.select {|d| d.type == 'event' }
g.plays.select {|p| p.type == 'event' }.size
g.plays.select {|p| p.type == 'event' }.map(&:description)
