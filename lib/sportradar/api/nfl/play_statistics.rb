module Sportradar
  module Api
    class Nfl::PlayStatistics < Data
      attr_accessor :response, :kick, :return, :rush, :defense, :receive, :punt, :penalty, :pass, :first_down, :field_goal, :extra_point, :defense, :down_conversion
      def initialize(data)
        @response = data
        @kick            = Nfl::PlayKickStatsitics.new(data['kick']) if data['kick']
        @return          = Nfl::PlayReturnStatistics.new(data['return']) if data['return']
        @rush            = Nfl::PlayRushStatistics.new(data['rush']) if data['rush']
        @defense         = parse_into_array(selector: data['defense'], klass: Nfl::PlayDefenseStatistics) if data['defense']
        @receive         = Nfl::PlayReceiveStatistics.new(data['receive']) if data['receive']
        @punt            = Nfl::PlayPuntStatsitics.new(data['punt']) if data['punt']
        @penalty         = Nfl::PlayPenaltyStatistics.new(data['penalty']) if data['penalty']
        @pass		         = Nfl::PlayPassingStatistics.new(data['pass']) if data['pass']
        @first_down      = Nfl::PlayFirstDownStatistics.new(data['first_down']) if data['first_down']
        @field_goal      = Nfl::PlayFieldGoalStatistics.new(data['field_goal']) if data['field_goal']
        @extra_point     = Nfl::PlayExtraPointStatistics.new(data['extra_point']) if data['extra_point']
        @down_conversion = Nfl::PlayDownConversionStatistics.new(data['down_conversion']) if data['down_conversion']
      end
    end

    class Nfl::PlayDownConversionStatistics < Data
      attr_accessor :attempt, :complete, :down, :nullified, :team
      def initialize(data)
        @attempt   = data['attempt']
        @complete  = data['complete']
        @down      = data['down']
        @team      = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @nullified = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayDefenseStatistics < Data
      attr_accessor :ast_tackle, :interception, :int_yards, :nullified, :pass_defended, :primary, :qb_hit, :sack, :sack_yards, :tlost, :tlost_yards, :team, :player, :tackle
      def initialize(data)
        @ast_tackle     = data['ast_tackle']
        @interception   = data['interception']
        @int_yards      = data['int_yards']
        @nullified      = data['nullified']
        @pass_defended  = data['pass_defended']
        @primary        = data['primary']
        @qb_hit         = data['qb_hit']
        @sack           = data['sack']
        @sack_yards     = data['sack_yards']
        @tlost          = data['tlost']
        @tlost_yards    = data['tlost_yards']
        @tackle         = data['tackle']
        @team           = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player         = Nfl::Player.new(data['player']) if data['player']
        @nullified      = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayExtraPointStatistics < Data
      attr_accessor :attempt, :nullified
      def initialize(data)
        @attempt   = data['attempt']
        @nullified = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayFieldGoalStatistics < Data
      attr_accessor :attempt, :att_yards, :missed, :yards, :nullified, :blocked, :team, :player
      def initialize(data)
        @attempt    = data['attempt']
        @att_yards  = data['att_yards']
        @missed     = data['missed']
        @blocked    = data['blocked']
        @yards      = data['yards']
        @nullified  = data['nullified']
        @team       = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player     = Nfl::Player.new(data['player']) if data['player']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayFirstDownStatistics < Data
      attr_accessor :category, :nullified, :team
      def initialize(data)
        @category   = data['category']
        @team       = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @nullified  = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayPassingStatistics < Data
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
        @team         = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player       = Nfl::Player.new(data['player']) if data['player']
        @nullified    = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayPenaltyStatistics < Data
      attr_accessor :penalty, :yards, :nullified, :team, :player
      def initialize(data)
        @penalty    = data['penalty'] if data['penalty']
        @yards      = data['yards'] if data['yards']
        @team       = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player     = Nfl::Player.new(data['player']) if data['player']
        @nullified  = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayPuntStatsitics < Data
      attr_accessor :attempt, :downed, :faircatch, :inside_20, :out_of_bounds, :touchback, :yards, :nullified, :team, :player
      def initialize(data)
        @attempt        = data['attempt']
        @downed         = data['downed']
        @inside_20      = data['inside_20']
        @out_of_bounds  = data['out_of_bounds']
        @touchback      = data['touchback']
        @yards          = data['yards']
        @team           = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player         = Nfl::Player.new(data['player']) if data['player']
        @nullified      = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayReceiveStatistics < Data
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
        @team              = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player            = Nfl::Player.new(data['player']) if data['player']
        @nullified         = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayRushStatistics < Data
      attr_accessor :attempt, :firstdown, :tlost, :tlost_yards, :yards, :inside_20, :goal_to_go, :team, :player, :nullified
      def initialize(data)
        @attempt     = data['attempt']
        @firstdown   = data['firstdown']
        @goal_to_go  = data['goal_to_go']
        @inside_20   = data['inside_20']
        @tlost       = data['tlost']
        @tlost_yards = data['tlost_yards']
        @touchdown   = data['touchdown']
        @yards       = data['yards']

        @team        = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player      = Nfl::Player.new(data['player']) if data['player']
        @nullified = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end
    

    class Nfl::PlayKickStatsitics < Data
      attr_accessor :attempt, :yards, :gross_yards, :touchback, :team, :player, :endzone, :inside_20, :nullified
      def initialize(data)
        @endzone      = data['endzone']
        @inside_20    = data['inside_20']
        @attempt      = data['attempt']
        @yards        = data['yards']
        @gross_yards  = data['gross_yards']
        @touchback    = data['touchback']
        @team         = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player       = Nfl::Player.new(data['player']) if data['player']
        @nullified    = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end

    class Nfl::PlayReturnStatistics < Data
      attr_accessor :category, :downed, :faircatch, :out_of_bounds, :return, :touchback, :yards, :team, :nullified
      def initialize(data)
        @category      = data['category']
        @downed        = data['downed']
        @faircatch     = data['faircatch']
        @out_of_bounds = data['out_of_bounds']
        @return        = data['return']
        @touchback     = data['touchback']
        @yards         = data['yards']
        @team          = Sportradar::Api::Nfl::Team.new(data['team']) if data['team']
        @player        = Nfl::Player.new(data['player']) if data['player']
        @nullified     = data['nullified']
      end

      def nullified?
        @nullified.to_s == 'true'
      end
    end
  end
end
