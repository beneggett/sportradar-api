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
          @possession_time = data.dig('summary', "possession_time")
          @avg_gain        = data.dig('summary', "avg_gain")
          @safeties        = data.dig('summary', "safeties")
          @turnovers       = data.dig('summary', "turnovers")
          @play_count      = data.dig('summary', "play_count")
          @rush_plays      = data.dig('summary', "rush_plays")
          @total_yards     = data.dig('summary', "total_yards")
          @lost_fumbles    = data.dig('summary', "lost_fumbles")
          @penalty_yards   = data.dig('summary', "penalty_yards")
          @return_yards    = data.dig('summary', "return_yards")
        end

        def turnovers
          @turnovers || passing.interceptions + fumbles.lost_fumbles
        end

        # :skip_test_coverage:
        # These are in methods rather than attributes to use them lazily. Each one is tested in it's respective class
        def rushing
          @rushing ||= if response["rushing"]
            response["rushing"] = parse_out_hashes response["rushing"]
            Sportradar::Api::Football::StatPack::Rushing.new(response["rushing"])
          end
        end

        def receiving
          @receiving ||= if response["receiving"]
            response["receiving"] = parse_out_hashes response["receiving"]
            Sportradar::Api::Football::StatPack::Receiving.new(response["receiving"])
          end
        end

        def punts
          @punts ||= if (data = response["punts"] || response["punting"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::Punts.new(data)
          end
        end

        def punt_returns
          @punt_returns ||= if (data = response["punt_returns"] || response["punt_return"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::PuntReturns.new(data)
          end
        end

        def penalties
          @penalties ||= if (data = response["penalties"] || response["penalty"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::Penalties.new(data)
          end
        end

        def passing
          @passing ||= if response["passing"]
            response["passing"] = parse_out_hashes response["passing"]
            Sportradar::Api::Football::StatPack::Passing.new(response["passing"])
          end
        end

        def misc_returns
          @misc_returns ||= if response["misc_returns"]
            response["misc_returns"] = parse_out_hashes response["misc_returns"]
            Sportradar::Api::Football::StatPack::MiscReturns.new(response["misc_returns"])
          end
        end

        def kickoffs
          @kickoffs ||= if response["kickoffs"]
            response["kickoffs"] = parse_out_hashes response["kickoffs"]
            Sportradar::Api::Football::StatPack::Kickoffs.new(response["kickoffs"])
          end
        end

        def kick_returns
          @kick_returns ||= if (data = response["kick_returns"] || response["kick_return"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::KickReturns.new(data)
          end
        end

        def int_returns
          @int_returns ||= if response["int_returns"]
            response["int_returns"] = parse_out_hashes response["int_returns"]
            Sportradar::Api::Football::StatPack::IntReturns.new(response["int_returns"])
          end
        end

        def fumbles
          @fumbles ||= if response["fumbles"]
            response["fumbles"] = parse_out_hashes response["fumbles"]
            Sportradar::Api::Football::StatPack::Fumbles.new(response["fumbles"])
          end
        end

        def field_goals
          @field_goals ||= if (data = response["field_goals"] || response["field_goal"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::FieldGoals.new(data)
          end
        end

        def extra_points
          @extra_points ||= if (data = response["extra_points"] || response["extra_point"])
            data = parse_out_hashes data
            Sportradar::Api::Football::StatPack::ExtraPoints.new(data)
          end
        end

        def defense
          @defense ||= if response["defense"]
            response["defense"] = parse_out_hashes response["defense"]
            Sportradar::Api::Football::StatPack::Defense.new(response["defense"])
          end
        end
        # :skip_test_coverage:
      end
    end
  end
end
