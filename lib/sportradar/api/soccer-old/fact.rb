module Sportradar
  module Api
    class Soccer::Fact < Data

      attr_accessor :id, :type, :time, :updated_time, :scratch, :reference_id, :clock, :team_id, :description, :period, :x, :y, :player_id, :card, :injury_time, :home_score, :away_score, :player_out_id, :player_in_id, :penalty, :owngoal, :header, :assist1_id, :winner_id, :draw, :response

      def initialize(data)
        @response = data
        @id = data["id"]
        @type = data["type"]
        @time = data["time"]
        @updated_time = data["updated_time"]
        @scratch = data["scratch"]
        @reference_id = data["reference_id"]
        @clock = data["clock"]
        @team_id = data["team_id"]
        @description = data["description"]
        @period = data["period"]
        @x = data["x"]
        @y = data["y"]
        @player_id = data["player_id"]
        @card = data["card"]
        @injury_time = data["injury_time"]
        @home_score = data["home_score"]
        @away_score = data["away_score"]
        @player_out_id = data["player_out_id"]
        @player_in_id = data["player_in_id"]
        @penalty = data["penalty"]
        @owngoal = data["owngoal"]
        @header = data["header"]
        @assist1_id = data["assist1_id"]
        @winner_id = data["winner_id"]
        @draw = data["draw"]
      end

      ## Fact Types
      # card
      # corner_kick
      # free_kick
      # game_resumed
      # goal
      # goal_kick
      # injury
      # injury_return
      # injury_time
      # keeper_save
      # match_ended
      # match_started
      # offside
      # penalty_awarded
      # penalty_missed
      # period_over
      # period_started
      # shot_blocked
      # shot_off_target
      # shot_on_target
      # substitution
      # throwin
    end
  end
end
