module Sportradar
  module Api
    module Football
      class Player < Data
        attr_accessor :response, :id, :preferred_name, :number, :name_full, :name_first, :name_last, :position, :birth_place, :college, :height, :weight, :averages, :totals, :draft, :depth, :api, :stats, :team

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @team     = opts[:team]

          @id = data["id"]

          update(data, **opts)
        end

        def first_name
          @name_first || @first_name
        end

        def last_name
          @name_last || @last_name
        end

        def name # to match api for NFL::Player
          name_full
        end
        def display_name
          preferred_name ? "#{preferred_name} #{last_name}" : name_full
        end

        def birth_date # to match api for NFL::Player
          @birthdate
        end

        def jersey
          @jersey_number
        end

        def update(data, **opts)
          @status           = data['status']            if data['status']
          @preferred_name   = data['preferred_name']  || data['name_preferred'] || @preferred_name
          @name_full        = data['name_full']       || data['name']           || @name_full
          @name_first       = data['name_first']      || data['first_name']     || @name_first
          @name_last        = data['name_last']       || data['last_name']      || @name_last
          @name_abbr        = data['name_abbr']       || data['abbr_name']      || @name_abbr
          @height           = data['height']            if data['height']
          @weight           = data['weight']            if data['weight']
          @position         = data['position']          if data['position']
          @primary_position = data['primary_position']  if data['primary_position']
          @jersey_number    = data['jersey_number'] || data['jersey'] || @jersey_number
          @experience       = data['experience']        if data['experience']
          @birth_place      = data['birth_place'].gsub(',,', ', ')       if data['birth_place']       # "Benin City,, NGA",
          @updated          = data['updated']           if data['updated']           # "2016-07-08T12:11:59+00:00",


          @depth            = data['depth']             if data['depth']
          @games_started    = data['games_started']     if data['games_started']
          @games_played     = data['games_played']      if data['games_played']
# NCAA specific below

          # update_injuries(data)
          # update_draft(data)

          if @stats = data['statistics']
            @totals = @stats
            # binding.pry
            @team.update_player_stats(self, @stats.dup, opts[:game])
          elsif @stats = data['games_played']
            @stats = data.dup
            %w[id name jersey reference position].each do |useless_key|
              @stats.delete(useless_key)
            end
            @totals = @stats
          else
            @totals = {}
          end

          self
        end

        def injured?
          # !!(@injury && @injury.out?)
        end

        def age
          # if birth_date.present?
          #   now = Time.now.utc.to_date
          #   dob = birth_date.to_date
          #   now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
          # end
        end

        def update_draft(data)
          # @draft = data['draft'] if data['draft']   # {"team_id"=>"583ec825-fb46-11e1-82cb-f4ce4684ea4c", "year"=>"2012", "round"=>"1", "pick"=>"30"},
        end
        def update_injuries(data)
          # @injury = Injury.new(data['injuries']) if data['injuries']
               # {"injury"=>
               #   {"id"=>"06423591-3fc1-4d2b-8c60-a3f30d735345",
               #    "comment"=>"Ezeli suffered a setback in his recovery from a procedure on his knee and there is no timetable for his return, according to Jason Quick of csnnw.com.",
               #    "desc"=>"Knee",
               #    "status"=>"Out",
               #    "start_date"=>"2016-10-25",
               #    "update_date"=>"2016-11-09"}}}
        end

      end
    end
  end
end

__END__

ncaafb = Marshal.load(File.binread('ncaafb.bin'));

t = ncaafb.teams.first;
t.get_roster;
t.players.first
t.players.first.totals

ncaafb = Marshal.load(File.binread('ncaafb.bin'));
t = ncaafb.teams.sample
data = t.get_season_stats(2016);
t.get_roster;
t.players.sample
t.players.sample.totals
