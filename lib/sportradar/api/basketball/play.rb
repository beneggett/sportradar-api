module Sportradar
  module Api
    module Basketball
      class Play < Data
        attr_accessor :response, :id, :clock, :event_type, :description, :statistics, :score, :team_id, :player_id, :quarter, :updated, :location, :possession, :on_court
        alias :type :event_type
        # @all_hash = {}
        # def self.new(data, **opts)
        #   existing = @all_hash[data['id']]
        #   if existing
        #     existing.update(data, **opts)
        #     existing
        #   else
        #     klass = subclass(data['event_type'])
        #     @all_hash[data['id']] = klass.new(data, **opts) rescue (puts data['event_type']; binding.pry)
        #   end
        # end
        def self.new(data, **opts)
          klass = subclass(data['event_type'])
          klass.new(data, **opts) rescue nil
        end
        # def self.all
        #   @all_hash.values
        # end

        def self.subclass(event_type)
          {
            "opentip"               => OpenTip,
            "twopointmiss"          => TwoPointMiss,
            "rebound"               => Rebound,
            "threepointmiss"        => ThreePointMiss,
            "twopointmade"          => TwoPointMade,
            "threepointmade"        => ThreePointMade,
            "turnover"              => Turnover,
            "personalfoul"          => PersonalFoul,
            "jumpball"              => Jumpball,
            "teamtimeout"           => TeamTimeout,
            "shootingfoul"          => ShootingFoul,
            "freethrowmade"         => FreeThrowMade,
            "freethrowmiss"         => FreeThrowMiss,
            "lineupchange"          => LineupChange,
            "offensivefoul"         => OffensiveFoul,
            "endperiod"             => EndPeriod,
            "openinbound"           => OpenInbound,
            "officialtimeout"       => OfficialTimeout,
            "kickball"              => Kickball,
            "tvtimeout"             => TvTimeout,
            "clearpathfoul"         => ClearPathFoul,
            "technicalfoul"         => TechnicalFoul,
            "review"                => Review,
            "defensivethreeseconds" => DefensiveThreeSeconds,
            "flagrantone"           => FlagrantOne,
            "flagranttwo"           => FlagrantTwo,
            "delay"                 => Delay,
            "ejection"              => Ejection,
            # abstract types, used for lookup purposes
            "foul"                  => Foul,
            "shotmade"              => ShotMade,
            "shotmiss"              => ShotMiss,
          }[event_type]
        end

        SHOT_TYPES = %w[driving pullup step back fadeaway putback floating finger roll turnaround reverse alley-oop]

        PLAY_TYPES = %w[clearpathfoul defensivethreeseconds delay ejection endperiod flagrantone flagranttwo freethrowmade freethrowmiss jumpball kickball offensivefoul officialtimeout openinbound opentip personalfoul possession rebound review shootingfoul teamtimeout technicalfoul threepointmade threepointmiss turnover tvtimeout twopointmade twopointmiss warning]
      end
    end
  end
end
