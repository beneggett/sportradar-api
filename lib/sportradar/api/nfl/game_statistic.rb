module Sportradar
  module Api
    class Nfl::GameStatistic < Data
      attr_accessor :response, :id, :rushing, :receiving, :punts, :punt_returns, :penalties, :passing, :misc_returns, :kickoffs, :kick_returns, :int_returns, :fumbles, :field_goals, :extra_points, :defense, :efficiency, :first_downs, :interceptions, :touchdowns, :name, :market, :alias, :reference, :possession_time, :avg_gain, :safeties, :turnovers, :play_count, :rush_plays, :total_yards, :lost_fumbles, :penalty_yards, :return_yards

      def initialize(data)
        @response        = data
        @id              = data["id"]
        
        @rushing         = Sportradar::Api::Nfl::Stat::Rushing.new(data["rushing"])
        @receiving       = Sportradar::Api::Nfl::Stat::Receiving.new(data["receiving"])
        @punts           = Sportradar::Api::Nfl::Stat::Punts.new(data["punts"])
        @punt_returns    = Sportradar::Api::Nfl::Stat::PuntReturns.new(data["punt_returns"])
        @penalties       = Sportradar::Api::Nfl::Stat::Penalties.new(data["penalties"])
        @passing         = Sportradar::Api::Nfl::Stat::Passing.new(data["passing"])
        @misc_returns    = Sportradar::Api::Nfl::Stat::MiscReturns.new(data["misc_returns"])
        @kickoffs        = Sportradar::Api::Nfl::Stat::Kickoffs.new(data["kickoffs"])
        @kick_returns    = Sportradar::Api::Nfl::Stat::KickReturns.new(data["kick_returns"])
        @int_returns     = Sportradar::Api::Nfl::Stat::IntReturns.new(data["int_returns"])
        @fumbles         = Sportradar::Api::Nfl::Stat::Fumbles.new(data["fumbles"])
        @field_goals     = Sportradar::Api::Nfl::Stat::FieldGoals.new(data["field_goals"])
        @extra_points    = Sportradar::Api::Nfl::Stat::ExtraPoints.new(data["extra_points"])
        @defense         = Sportradar::Api::Nfl::Stat::Defense.new(data["defense"])
        # end of combo team/player stats
        @efficiency      = data["efficiency"]
        @first_downs     = data["first_downs"]
        @interceptions   = data["interceptions"]
        @touchdowns      = data["touchdowns"]
        @name            = data["name"]
        @market          = data["market"]
        @alias           = data["alias"]
        @reference       = data["reference"]
        @possession_time = data["possession_time"]
        @avg_gain        = data["avg_gain"]
        @safeties        = data["safeties"]
        @turnovers       = data["turnovers"]
        @play_count      = data["play_count"]
        @rush_plays      = data["rush_plays"]
        @total_yards     = data["total_yards"]
        @lost_fumbles    = data["lost_fumbles"]
        @penalty_yards   = data["penalty_yards"]
        @return_yards    = data["return_yards"]
      end

    end
  end
end
