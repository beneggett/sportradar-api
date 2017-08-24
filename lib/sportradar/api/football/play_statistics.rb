module Sportradar
  module Api
    module Football
      class PlayStatistics < Data
        attr_accessor :response, :kick, :return, :rush, :defense, :receive, :punt, :penalty, :pass, :first_down, :field_goal, :extra_point, :defense, :down_conversion
        def initialize(data)
          data = [data] if data.is_a?(Hash)
          @response = data
          data.each do |hash|
            var = instance_variable_get("@#{hash['stat_type']}")
            unless var
              instance_variable_set("@#{hash['stat_type']}", [])
              var = instance_variable_get("@#{hash['stat_type']}")
            end
            klass = self.class.stat_type_classes[hash['stat_type']] || MiscStatistics
            var << klass.new(hash)
          end
        end

        def players
          @players ||= [:kick, :return, :rush, :defense, :receive, :punt, :penalty, :pass, :field_goal, :defense, :down_conversion].flat_map do |stat_type|
            Array(send(stat_type)).map { |stat| stat.player.team = stat.team.id; stat.player }
          end
        end

        def players_by_team
          @players_by_team ||= players.group_by(&:team)
        end

        def self.stat_type_classes
          @stat_type_classes ||= {
            'kick'            => PlayKickStatistics,
            'return'          => PlayReturnStatistics,
            'rush'            => PlayRushStatistics,
            'fumble'          => PlayFumbleStatistics,
            'defense'         => PlayDefenseStatistics,
            'receive'         => PlayReceiveStatistics,
            'punt'            => PlayPuntStatistics,
            'penalty'         => PlayPenaltyStatistics,
            'pass'            => PlayPassingStatistics,
            'first_down'      => PlayFirstDownStatistics,
            'field_goal'      => PlayFieldGoalStatistics,
            'extra_point'     => PlayExtraPointStatistics,
            'down_conversion' => PlayDownConversionStatistics,
            'conversion'      => ConversionStatistics,
            'block'           => BlockStatistics,
            'misc'            => MiscStatistics,
          }.freeze
        end
      end

      class MiscStatistics < Data
        attr_reader :team, :player, :yards
        def initialize(data)
          @yards          = data['yards']
          @team           = OpenStruct.new(data['team']) if data['team']
          @player         = OpenStruct.new(data['player']) if data['player']
        end
      end

      class BlockStatistics < Data
        attr_reader :team, :player, :block, :category
        def initialize(data)
          @category       = data['category']
          @block          = data['block']
          @team           = OpenStruct.new(data['team']) if data['team']
          @player         = OpenStruct.new(data['player']) if data['player']
        end
      end

      class PlayDownConversionStatistics < Data
        attr_accessor :attempt, :complete, :down, :nullified, :team, :player
        def initialize(data)
          @attempt   = data['attempt']
          @complete  = data['complete']
          @down      = data['down']
          @team      = OpenStruct.new(data['team']) if data['team']
          @player    = OpenStruct.new(data['player']) if data['player']
          @nullified = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayDefenseStatistics < Data
        attr_accessor :ast_tackle, :interception, :int_yards, :nullified, :pass_defended, :primary, :qb_hit, :sack, :sack_yards, :tlost, :tlost_yards, :team, :player, :tackle, :int_touchdown
        def initialize(data)
          @ast_tackle     = data['ast_tackle']
          @interception   = data['interception']
          @int_yards      = data['int_yards']
          @int_touchdown  = data['int_touchdown']
          @nullified      = data['nullified']
          @pass_defended  = data['pass_defended']
          @primary        = data['primary']
          @qb_hit         = data['qb_hit']
          @sack           = data['sack']
          @sack_yards     = data['sack_yards']
          @tlost          = data['tlost']
          @tlost_yards    = data['tlost_yards']
          @tackle         = data['tackle']
          @team           = OpenStruct.new(data['team']) if data['team']
          @player         = OpenStruct.new(data['player']) if data['player']
          @nullified      = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayExtraPointStatistics < Data
        attr_accessor :attempt, :nullified
        def initialize(data)
          @attempt   = data['attempt']
          @nullified = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayFieldGoalStatistics < Data
        attr_accessor :attempt, :att_yards, :missed, :yards, :nullified, :blocked, :team, :player
        def initialize(data)
          @attempt    = data['attempt']
          @att_yards  = data['att_yards']
          @missed     = data['missed']
          @blocked    = data['blocked']
          @yards      = data['yards']
          @nullified  = data['nullified']
          @team       = OpenStruct.new(data['team']) if data['team']
          @player     = OpenStruct.new(data['player']) if data['player']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayFirstDownStatistics < Data
        attr_accessor :category, :nullified, :team
        def initialize(data)
          @category   = data['category']
          @team       = OpenStruct.new(data['team']) if data['team']
          @nullified  = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayPassingStatistics < Data
        attr_accessor :attempt, :att_yards, :complete, :firstdown, :goaltogo, :inside_20, :interception, :sack, :sack_yards, :touchdown, :yards, :nullified, :team, :player
        def initialize(data)
          @attempt      = data['attempt']
          @att_yards    = data['att_yards']
          @complete     = data['complete']
          @firstdown    = data['firstdown']
          @goaltogo     = data['goaltogo']
          @inside_20    = data['inside_20']
          @interception = data['interception']
          @sack         = data['sack']
          @sack_yards   = data['sack_yards']
          @touchdown    = data['touchdown']
          @yards        = data['yards']
          @team         = OpenStruct.new(data['team']) if data['team']
          @player       = OpenStruct.new(data['player']) if data['player']
          @nullified    = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayPenaltyStatistics < Data
        attr_accessor :penalty, :yards, :nullified, :team, :player
        def initialize(data)
          @penalty    = data['penalty'] if data['penalty']
          @yards      = data['yards'] if data['yards']
          @team       = OpenStruct.new(data['team']) if data['team']
          @player     = OpenStruct.new(data['player']) if data['player']
          @nullified  = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayPuntStatistics < Data
        attr_accessor :attempt, :downed, :faircatch, :inside_20, :out_of_bounds, :touchback, :yards, :nullified, :team, :player
        def initialize(data)
          data = data.first if data.is_a?(Array)
          @attempt        = data['attempt']
          @downed         = data['downed']
          @inside_20      = data['inside_20']
          @out_of_bounds  = data['out_of_bounds']
          @touchback      = data['touchback']
          @yards          = data['yards']
          @team           = OpenStruct.new(data['team']) if data['team']
          @player         = OpenStruct.new(data['player']) if data['player']
          @nullified      = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayReceiveStatistics < Data
        attr_accessor :firstdown, :goaltogo, :inside_20, :reception, :target, :touchdown, :yards, :yards_after_catch, :nullified, :team, :player
        def initialize(data)
          @firstdown         = data['firstdown']
          @goaltogo          = data['goaltogo']
          @inside_20         = data['inside_20']
          @reception         = data['reception']
          @target            = data['target']
          @touchdown         = data['touchdown']
          @yards             = data['yards']
          @yards_after_catch = data['yards_after_catch']
          @team              = OpenStruct.new(data['team']) if data['team']
          @player            = OpenStruct.new(data['player']) if data['player']
          @nullified         = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class PlayFumbleStatistics < Data
        attr_reader :own_rec, :own_rec_yards, :forced, :team, :player
        def initialize(data)
          @own_rec        = data['own_rec']
          @own_rec_yards  = data['own_rec_yards']
          @forced         = data['forced']

          @team        = OpenStruct.new(data['team'])   if data['team']
          @player      = OpenStruct.new(data['player']) if data['player']
        end
      end
        
      class PlayRushStatistics < Data
        attr_accessor :attempt, :firstdown, :tlost, :tlost_yards, :yards, :inside_20, :goal_to_go, :team, :player, :nullified, :touchdown
        def initialize(data)
          @attempt     = data['attempt']
          @firstdown   = data['firstdown']
          @goal_to_go  = data['goal_to_go']
          @inside_20   = data['inside_20']
          @tlost       = data['tlost']
          @tlost_yards = data['tlost_yards']
          @touchdown   = data['touchdown']
          @yards       = data['yards']

          @team        = OpenStruct.new(data['team']) if data['team']
          @player      = OpenStruct.new(data['player']) if data['player']
          @nullified = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end
      

      class PlayKickStatistics < Data
        attr_accessor :attempt, :yards, :gross_yards, :touchback, :team, :player, :endzone, :inside_20, :nullified
        def initialize(data)
          @endzone      = data['endzone']
          @inside_20    = data['inside_20']
          @attempt      = data['attempt']
          @yards        = data['yards']
          @gross_yards  = data['gross_yards']
          @touchback    = data['touchback']
          @team         = OpenStruct.new(data['team']) if data['team']
          @player       = OpenStruct.new(data['player']) if data['player']
          @nullified    = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

      class ConversionStatistics < Data
        attr_reader :stat_type, :attempt, :complete, :category, :player, :team
        def initialize(data)
          @stat_type  = data['stat_type']
          @attempt    = data['attempt']
          @complete   = data['complete']
          @category   = data['category']
          @team         = OpenStruct.new(data['team']) if data['team']
          @player       = OpenStruct.new(data['player']) if data['player']
        end
      end

      class PlayReturnStatistics < Data
        attr_accessor :category, :downed, :faircatch, :out_of_bounds, :return, :touchback, :yards, :team, :nullified, :player, :touchdown
        def initialize(data)
          @category      = data['category']
          @downed        = data['downed']
          @faircatch     = data['faircatch']
          @out_of_bounds = data['out_of_bounds']
          @return        = data['return']
          @touchback     = data['touchback']
          @touchdown     = data['touchdown']
          @yards         = data['yards']
          @team          = OpenStruct.new(data['team']) if data['team']
          @player        = OpenStruct.new(data['player']) if data['player']
          @nullified     = data['nullified']
        end

        def nullified?
          @nullified.to_s == 'true'
        end
      end

    end
  end
end