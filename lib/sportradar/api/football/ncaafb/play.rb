module Sportradar
  module Api
    module Football
      class Ncaaf
        class Play < Sportradar::Api::Football::Play

          def initialize(data, **opts)
            @response = data
            @id       = data["id"]
            @api      = opts[:api]

            update(data, **opts)
          end

          def update(data, **opts)
            @clock        = data["clock"]        if data["clock"]
            @type         = data["type"]         if data["type"]
            @summary      = data["summary"]      if data["summary"]
            @updated      = data["updated"]      if data["updated"]
            @side         = data["side"]         if data["side"]
            @yard_line    = data["yard_line"]    if data["yard_line"]
            @down         = data["down"]         if data["down"]
            @yfd          = data["yfd"]          if data["yfd"]
            @formation    = data["formation"]    if data["formation"]
            @direction    = data["direction"]    if data["direction"]
            @distance     = data["distance"]     if data["distance"]
            @participants = data["participants"] if data["participants"]
            @details      = data["details"]      if data["details"]
            @play_type    = data["play_type"]    if data["play_type"]
            @sequence     = data["sequence"]     if data["sequence"]

            # NFL stuff
            # @type              = data["type"]
            # @alt_description   = data["alt_description"]
            # @away_points       = data["away_points"]
            # @clock             = data["clock"]
            # @description       = data["description"]
            # # @end_situation   = Sportradar::Api::Nfl::Situation.new data["end_situation"] if data["end_situation"]
            # @team_id           = end_situation.team_id if end_situation
            # @home_points       = data["home_points"]
            # @play_clock        = data["play_clock"]
            # @reference         = data["reference"]
            # @score             = data["score"]
            # @scoring_play      = data["scoring_play"]
            # @sequence          = data["sequence"]
            # # @start_situation = Sportradar::Api::Nfl::Situation.new data["start_situation"] if data["start_situation"]
            # # @statistics      = Sportradar::Api::Nfl::PlayStatistics.new data["statistics"] if data["statistics"]
            # parse_player if @statistics
            # @wall_clock        = data["wall_clock"]

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
end
