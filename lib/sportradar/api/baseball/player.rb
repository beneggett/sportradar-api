module Sportradar
  module Api
    module Baseball
      class Player < Data
        attr_accessor :response, :id, :number, :full_name, :first_name, :last_name, :position, :birth_place, :college, :height, :weight, :draft, :hitting, :pitching, :fielding

        def initialize(data, **opts)
          @response = data # comment this out when done developing
          @api      = opts[:api]
          # @team     = opts[:team]

          @id = data["id"]

          update(data, **opts)
        end

        def name # to match api for NFL::Player
          full_name
        end
        def display_name
          full_name
        end
        def jersey
          @jersey_number
        end

        def birth_date # to match api for NFL::Player
          @birthdate
        end

        def update(data, **opts)
          @status           = data['status']            if data['status']            # "ACT",
          @full_name        = data['full_name']         if data['full_name']         # "Festus Ezeli",
          @first_name       = data['first_name']        if data['first_name']        # "Festus",
          @last_name        = data['last_name']         if data['last_name']         # "Ezeli",
          @abbr_name        = data['abbr_name']         if data['abbr_name']         # "F.Ezeli",
          @height           = data['height']            if data['height']            # "83",
          @weight           = data['weight']            if data['weight']            # "265",
          @position         = data['position']          if data['position']          # "C",
          @primary_position = data['primary_position']  if data['primary_position']  # "C",
          @jersey_number    = data['jersey_number']     if data['jersey_number']     # "31",
          @experience       = data['experience']        if data['experience']        # "3",
          @birth_place      = data['birth_place'].gsub(',,', ', ')       if data['birth_place']       # "Benin City,, NGA",
          @updated          = data['updated']           if data['updated']           # "2016-07-08T12:11:59+00:00",

          @college          = data['college']           if data['college']           # "Vanderbilt",
          @birthdate        = data['birthdate']         if data['birthdate']         # "1989-10-21",

          update_injuries(data)
          update_draft(data)

          # @team.update_player_stats(self, data['statistics'], opts[:game])  if data['statistics']
          if stats = data['statistics']
            @fielding = stats.dig('fielding', 'overall')
            @pitching = stats.dig('pitching', 'overall')
            @hitting  = stats.dig('hitting', 'overall')

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
          @draft = data['draft'] if data['draft']   # {"team_id"=>"583ec825-fb46-11e1-82cb-f4ce4684ea4c", "year"=>"2012", "round"=>"1", "pick"=>"30"},
        end
        def update_injuries(data)
          @injury = Injury.new(data['injuries']) if data['injuries']
               # {"injury"=>
               #   {"id"=>"06423591-3fc1-4d2b-8c60-a3f30d735345",
               #    "comment"=>"Ezeli suffered a setback in his recovery from a procedure on his knee and there is no timetable for his return, according to Jason Quick of csnnw.com.",
               #    "desc"=>"Knee",
               #    "status"=>"Out",
               #    "start_date"=>"2016-10-25",
               #    "update_date"=>"2016-11-09"}}}
        end

        def api
          @api || Sportradar::Api::Baseball::Mlb.new
        end

      end
    end
  end
end

__END__

mlb = Sportradar::Api::Baseball::Mlb::Hierarchy.new
mlb.get_hierarchy;
t = mlb.teams.first;
t.get_season_stats(2016);
t.players.sample

