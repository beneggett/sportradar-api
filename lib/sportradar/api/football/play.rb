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
          @alt_description   = data["alt_description"]
          @away_points       = data["away_points"]
          @clock             = data["clock"]
          @description       = data["description"]
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
          @type              = data["type"]
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
