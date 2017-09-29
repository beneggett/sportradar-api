module Sportradar
  module Api
    module Hockey
      class Player < Data
        attr_accessor :response, :id, :birth_place, :jersey_number, :status, :full_name, :first_name, :last_name, :abbr_name, :height, :weight, :handedness, :position, :primary_position, :birthdate, :updated

        attr_reader :stats, :averages, :totals

        def initialize(data, **opts)
          @response = data # comment this out when done developing
          @api      = opts[:api]
          @team     = opts[:team]

          @id = data["id"]

          update(data, **opts)
        end

        def name # to match api for NFL::Player
          full_name
        end
        def display_name
          full_name || "#{@preferred_name || @first_name} #{@last_name}"
        end
        def jersey
          @jersey_number
        end

        def birth_date # to match api for NFL::Player
          @birthdate
        end

        def update(data, **opts)
          # @depth            = data['depth']             if data['depth']
          # @experience       = data['experience']        if data['experience']
          @birth_place      = data['birth_place'].gsub(',,', ', ')       if data['birth_place']
          # @college          = data['college']           if data['college']

          # from team roster
          @jersey_number    = data['jersey_number']     if data['jersey_number']
          @status           = data['status']            if data['status']
          @full_name        = data['full_name']         if data['full_name']
          @first_name       = data['first_name']        if data['first_name']
          @last_name        = data['last_name']         if data['last_name']
          @abbr_name        = data['abbr_name']         if data['abbr_name']
          @height           = data['height']            if data['height']
          @weight           = data['weight']            if data['weight']
          @handedness       = data['handedness']        if data['handedness']
          @position         = data['position']          if data['position']
          @primary_position = data['primary_position']  if data['primary_position']
          @birthdate        = data['birthdate']         if data['birthdate']
          @updated          = data['updated']           if data['updated']


          update_injuries(data)
          update_draft(data)

          if stats = data['statistics']
            @team.update_player_stats(self, data['statistics'], opts[:game])
            @stats = stats
            @totals = stats['total']
            @averages = stats['average']

            # used to be @team, lets leave as opt until it needs to go back
            opts[:team].update_player_stats(self, stats)
          end

          self
        end

        def injured?
          !!(@injury && @injury.out?)
        end

        def age
          if birth_date.present?
            now = Time.now.utc.to_date
            dob = birth_date.to_date
            now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
          end
        end

        def update_draft(data)
          @draft = data['draft'] if data['draft']
        end
        def update_injuries(data)
          # @injury = Injury.new(data['injuries']) if data['injuries']
        end

        def api
          @api || Sportradar::Api::Hockey::Nhl::Api.new
        end

      end
    end
  end
end

__END__

nhl = Sportradar::Api::Hockey::Nhl.new
nhl.get_hierarchy;
t = nhl.teams.first;
t.get_season_stats(2016);
t.players.sample

{"id"=>"160348a8-18a8-4767-8902-b50805166972",
 "status"=>"ACT",
 "full_name"=>"Kenney Morrison",
 "first_name"=>"Kenney",
 "last_name"=>"Morrison",
 "abbr_name"=>"K.Morrison",
 "height"=>74,
 "weight"=>210,
 "handedness"=>"R",
 "position"=>"D",
 "primary_position"=>"D",
 "birth_place"=>"Lloydminster, AB, CAN",
 "birthdate"=>"1992-02-13",
 "updated"=>"2017-09-12T13:45:43+00:00"}


{"id"=>"42c8522c-0f24-11e2-8525-18a905767e44",
   "full_name"=>"Craig Smith",
   "first_name"=>"Craig",
   "last_name"=>"Smith",
   "position"=>"F",
   "primary_position"=>"RW",
   "jersey_number"=>"15",
   "statistics"=>
    {"total"=>
          {"games_played"=>78,
           "goals"=>12,
           "assists"=>17,
           "penalties"=>15,
           "penalty_minutes"=>30,
           "shots"=>155,
           "blocked_att"=>81,
           "missed_shots"=>81,
           "hits"=>93,
           "giveaways"=>35,
           "takeaways"=>34,
           "blocked_shots"=>16,
           "faceoffs_won"=>51,
           "faceoffs_lost"=>60,
           "winning_goals"=>1,
           "plus_minus"=>7,
           "games_scratched"=>4,
           "games_started"=>14,
           "shooting_pct"=>7.7,
           "faceoff_win_pct"=>45.9,
           "faceoffs"=>111,
           "points"=>29},
     "powerplay"=>{"shots"=>9, "goals"=>2, "missed_shots"=>10, "assists"=>1, "faceoffs_won"=>7, "faceoffs"=>7, "faceoffs_lost"=>0, "faceoffs_win_pct"=>100.0},
     "shorthanded"=>{"shots"=>1, "goals"=>0, "missed_shots"=>0, "assists"=>0, "faceoffs_won"=>1, "faceoffs"=>2, "faceoffs_lost"=>1, "faceoffs_win_pct"=>50.0},
     "evenstrength"=>{"shots"=>145, "goals"=>10, "missed_shots"=>71, "assists"=>16, "faceoffs_won"=>43, "faceoffs"=>95, "faceoffs_lost"=>52, "faceoffs_win_pct"=>45.3},
     "penalty"=>{"shots"=>1, "goals"=>0, "missed_shots"=>0},
     "shootout"=>{"shots"=>1, "goals"=>0, "missed_shots"=>1},
     "average"=>{"assists"=>0.22, "blocked_shots"=>0.21, "points"=>0.37, "blocked_att"=>1.04, "penalties"=>0.19, "missed_shots"=>1.04, "hits"=>1.19, "shots"=>1.99, "takeaways"=>0.44, "giveaways"=>0.45, "goals"=>0.15, "penalty_minutes"=>0.38},
     :player=>#<Sportradar::Api::Hockey::Player:0x007fbf62e214a8 ...>},
   "time_on_ice"=>{"total"=>{"shifts"=>1505, "total"=>"1078:12"}, "average"=>{"shifts"=>19.29, "total"=>"13:49"}}}

