module Sportradar
  module Api
    module Football
      class GameStats < Data
        attr_accessor :response, :id, :efficiency, :first_downs, :interceptions, :touchdowns, :name, :market, :alias, :reference, :possession_time, :avg_gain, :safeties, :turnovers, :play_count, :rush_plays, :total_yards, :lost_fumbles, :penalty_yards, :return_yards

        # attr_writer :rushing, :receiving, :punts, :punt_returns, :penalties, :passing, :misc_returns, :kickoffs, :kick_returns, :int_returns, :fumbles, :field_goals, :extra_points, :defense # probably not necessary, but leaving here in case we want it later

        def initialize(data)
          @response        = data
          @id              = data["id"]
          @name            = data["name"]
          @market          = data["market"]
          @alias           = data["alias"]
          @reference       = data["reference"]
          @efficiency      = data["efficiency"]
          @first_downs     = data["first_downs"]
          @interceptions   = data["interceptions"]
          @touchdowns      = data["touchdowns"]
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

        # :skip_test_coverage:
        # These are in methods rather than attributes to use them lazily. Each one is tested in it's respective class
        def rushing
          if response["rushing"]
            response["rushing"] = parse_out_hashes response["rushing"]
            @rushing       ||= Sportradar::Api::Football::StatPack::Rushing.new(response["rushing"])
          end
        end

        def receiving
          if response["receiving"]
            response["receiving"] = parse_out_hashes response["receiving"]
            @receiving     ||= Sportradar::Api::Football::StatPack::Receiving.new(response["receiving"])
          end
        end

        def punts
          if response["punts"]
            response["punts"] = parse_out_hashes response["punts"]
            @punts         ||= Sportradar::Api::Football::StatPack::Punts.new(response["punts"])
          end
        end

        def punt_returns
          if response["punt_returns"]
            response["punt_returns"] = parse_out_hashes response["punt_returns"]
            @punt_returns  ||= Sportradar::Api::Football::StatPack::PuntReturns.new(response["punt_returns"])
          end
        end

        def penalties
          if response["penalties"]
            response["penalties"] = parse_out_hashes response["penalties"]
            @penalties     ||= Sportradar::Api::Football::StatPack::Penalties.new(response["penalties"])
          end
        end

        def passing
          if response["passing"]
            response["passing"] = parse_out_hashes response["passing"]
            @passing       ||= Sportradar::Api::Football::StatPack::Passing.new(response["passing"])
          end
        end

        def misc_returns
          if response["misc_returns"]
            response["misc_returns"] = parse_out_hashes response["misc_returns"]
            @misc_returns  ||= Sportradar::Api::Football::StatPack::MiscReturns.new(response["misc_returns"])
          end
        end

        def kickoffs
          if response["kickoffs"]
            response["kickoffs"] = parse_out_hashes response["kickoffs"]
            @kickoffs      ||= Sportradar::Api::Football::StatPack::Kickoffs.new(response["kickoffs"])
          end
        end

        def kick_returns
          if response["kick_returns"]
            response["kick_returns"] = parse_out_hashes response["kick_returns"]
            @kick_returns  ||= Sportradar::Api::Football::StatPack::KickReturns.new(response["kick_returns"])
          end
        end

        def int_returns
          if response["int_returns"]
            response["int_returns"] = parse_out_hashes response["int_returns"]
            @int_returns   ||= Sportradar::Api::Football::StatPack::IntReturns.new(response["int_returns"])
          end
        end

        def fumbles
          if response["fumbles"]
            response["fumbles"] = parse_out_hashes response["fumbles"]
            @fumbles       ||= Sportradar::Api::Football::StatPack::Fumbles.new(response["fumbles"])
          end
        end

        def field_goals
          if response["field_goals"]
            response["field_goals"] = parse_out_hashes response["field_goals"]
            @field_goals   ||= Sportradar::Api::Football::StatPack::FieldGoals.new(response["field_goals"])
          end
        end

        def extra_points
          if response["extra_points"]
            response["extra_points"] = parse_out_hashes response["extra_points"]
            @extra_points  ||= Sportradar::Api::Football::StatPack::ExtraPoints.new(response["extra_points"])
          end
        end

        def defense
          if response["defense"]
            response["defense"] = parse_out_hashes response["defense"]
            @defense       ||= Sportradar::Api::Football::StatPack::Defense.new(response["defense"])
          end
        end
        # :skip_test_coverage:
      end
    end
  end
end
