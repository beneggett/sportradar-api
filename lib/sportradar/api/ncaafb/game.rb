module Sportradar
  module Api
    class Ncaafb
      class Game < Data
        # attr_accessor :response, :id, :status, :reference, :number, :scheduled, :entry_mode, :venue, :home, :away, :broadcast, :number, :attendance, :utc_offset, :weather, :clock, :quarter, :summary, :situation, :last_event, :scoring, :scoring_drives, :quarters, :stats, :week, :season
        attr_accessor :response, :id, :scheduled, :coverage, :home_rotation, :away_rotation, :home, :away, :status, :neutral_site, :home_points, :away_points, :venue, :weather, :broadcast, :links, :summary, :scoring_drives, :teams

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @week     = opts[:week]

          @id            = response["id"]
          @year          = response['year'] || @week&.season.year
          @type          = response['type'] || @week&.season.type
          @week_number   = response['week'] || @week&.sequence
          @coverage      = response['coverage']
          @scheduled     = Time.parse(response["scheduled"]) if response["scheduled"]
          @home          = Team.new(response['home'], api: api, game: self)
          @away          = Team.new(response['away'], api: api, game: self)
          @status        = response['status']
          @home_rotation = response['home_rotation']
          @away_rotation = response['away_rotation']
          @neutral_site  = response['neutral_site'] == 'true'
          @home_points   = response['home_points']
          @away_points   = response['away_points']
          @venue         = response['venue']
          # @venue         = Sportradar::Api::Ncaafb::Venue.new(response["venue"]) if response["venue"]
          @weather       = response['weather']
          @broadcast     = response['broadcast']
          @links         = structure_links response.dig('links', 'link')

          @teams_hash    = { @home.id => @home, @away.id => @away }
        end

        # def current_score
        #   "#{summary.home.points}-#{summary.away.points}" if summary
        # end

        def box
          @box ||= get_boxscore
        end

        def pbp
          @pbp ||= drives
        end

        def roster
          @roster ||= get_roster
        end

        def quarters
          @quarters ||= get_pbp
        end

        def drives
          @drives ||= quarters.flat_map(&:drives)
        end

        def plays
          @plays ||= quarters.flat_map(&:plays)
        end

        def teams(id = nil)
          id ? @teams_hash[id.to_i] : @teams_hash.values
        end


        def update(data)
          @attendance     = data['attendance']                          if data['attendance']
          @summary        = data['summary']                             if data['summary']
          @scheduled      = Time.parse(data["scheduled"])               if data["scheduled"]
          home.update(data['home'])                   if data['home']
          away.update(data['away'])                   if data['away']
          @status         = data['status']                              if data['status']

          @completed      = Time.parse(data['completed'])               if data['completed']
          @quarter        = data['quarter']                             if data['quarter']
          @clock          = data['clock']                               if data['clock']
          @scoring_drives = set_scoring_drives(data['scoring_drives'])  if data['scoring_drives']
        end

        private

        def set_scoring_drives(data)
          parse_into_array_with_options(selector: data, klass: Sportradar::Api::Ncaafb::Drive, api: api, game: self)
        end
        # def set_team_rosters(data)
        #   update_data(@teams, data)
        # end

        def path_base
          "#{ year }/#{ type }/#{ week_number }/#{ away }/#{ home }"
        end
        def path_box
          links['boxscore'] || "#{ path_base }/boxscore"
        end
        def path_extended_box
          "#{ path_base }/extended-boxscore"
        end
        def path_pbp
          links['pbp'] || "#{ path_base }/pbp"
        end
        def path_roster
          links['roster'] || "#{ path_base }/roster"
        end
        def path_summary
          links['summary'] || "#{ path_base }/summary"
        end

        def get_boxscore
          data = api.get_data(path_box)['game']
          update(data)
          self
        end
        def get_pbp
          data = api.get_data(path_pbp)['game']
          update(data)
          @pbp = set_pbp(data['quarter'])
        end
        def get_roster
          data = api.get_data(path_roster)['game']
          update_data(@teams_hash, data['team'])
        end

        def set_pbp(data)
          @quarters = parse_into_array_with_options(selector: data, klass: Sportradar::Api::Ncaafb::Quarter, api: api, game: self)
          @drives = nil # to clear empty array empty
          @plays  = nil # to clear empty array empty
          @quarters
        end

        def api
          @api || Sportradar::Api::Ncaafb.new
        end
        # def set_scoring_drives
        #   if response["scoring_drives"] && response["scoring_drives"]["drive"]
        #     if response["scoring_drives"]["drive"].is_a?(Array)
        #       @scoring_drives = response["scoring_drives"]["drive"].map {|scoring_drive| Sportradar::Api::Nfl::Drive.new scoring_drive }
        #     elsif response["scoring_drives"]["drive"].is_a?(Hash)
        #       @scoring_drives = [ Sportradar::Api::Nfl::Drive.new(response["scoring_drives"]["drive"]) ]
        #     end
        #   end
        # end
        KEYS_SCHEDULE = ["id", "scheduled", "coverage", "home_rotation", "away_rotation", "home", "away", "status", "neutral_site", "home_points", "away_points", "venue", "weather", "broadcast", "links"]

      end
    end
  end
end

__END__

sr = Sportradar::Api::Ncaafb.new;
ss = sr.schedule;
g = ss.weeks.first.games.first;
r = g.roster;
box = g.box;
pbp = g.pbp;
pbp.first.class # => Quarter
pbp.first.plays.count # => 9
