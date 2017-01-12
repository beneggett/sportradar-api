module Sportradar
  module Api
    module Basketball
      class Nba
        class Game < Data
          attr_accessor :response, :id, :home, :away, :home_id, :away_id, :score, :scoring, :status, :scheduled, :venue, :broadcast, :clock, :duration, :attendance, :quarter, :team_stats, :player_stats, :changes, :media_timeouts
          @all_hash = {}
          def self.new(data, **opts)
            existing = @all_hash[data['id']]
            if existing
              existing.update(data, **opts)
              existing
            else
              @all_hash[data['id']] = super
            end
          end
          def self.all
            @all_hash.values
          end

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]
            # @season   = opts[:season]
            @updates  = {}
            @changes  = {}
            
            @score          = {}
            @team_stats     = {}
            @player_stats   = {}
            @scoring_raw    = Scoring.new(data, game: self)
            @teams_hash     = {}
            @quarters_hash  = {}
            
            @id = data['id']
            
            update(data, **opts)
          end
          def timeouts
            {}
          end

          def overview
            Overview.new(self)
          end
          def tied?
            @score[away_id].to_i == @score[home_id].to_i
          end
          def points(team_id)
            team_id.is_a?(Symbol) ? @score[@team_ids[team_id]].to_i : @score[team_id].to_i
          end
          def stats(team_id)
            team_id.is_a?(Symbol) ? @team_stats[@team_ids[team_id]].to_i : @team_stats[team_id].to_i
          end

          def scoring
            @scoring_raw.scores
          end
          def update_score(score)
            @score.merge!(score)
          end
          def update_stats(team, stats)
            @team_stats.merge!(team.id => stats.merge!(team: team))
          end
          def update_player_stats(player, stats)
            @player_stats.merge!(player.id => stats.merge!(player: player))
          end

          def parse_score(data)
            update_score(data.dig('home', 'id') => data.dig('home', 'points').to_i)
            update_score(data.dig('away', 'id') => data.dig('away', 'points').to_i)
          end
          def clock_seconds
            return unless @clock
            m,s = @clock.split(':')
            m.to_i * 60 + s.to_i
          end

          def update(data, source: nil, **opts)
            # via pbp
            @status       = data['status']                if data['status']
            @coverage     = data['coverage']              if data['coverage']
            @home_id      = data['home_team']             if data['home_team'] # GUID
            @away_id      = data['away_team']             if data['away_team'] # GUID
            @home_points  = data['home_points'].to_i      if data['home_points']
            @away_points  = data['away_points'].to_i      if data['away_points']

            @scheduled    = Time.parse(data["scheduled"]) if data["scheduled"]
            @venue        = Venue.new(data['venue']) if data['venue']
            @broadcast    = Broadcast.new(data['broadcast']) if data['broadcast']
            @home         = Team.new(data['home'], api: api, game: self) if data['home']
            @away         = Team.new(data['away'], api: api, game: self) if data['away']

            @duration     = data['duration']              if data['duration']
            @clock        = data['clock']                 if data['clock']
            @attendance   = data['attendance']            if data['attendance']
            @lead_changes = data['lead_changes']          if data['lead_changes']
            @times_tied   = data['times_tied']            if data['times_tied']

            @team_ids     = { home: @home_id, away: @away_id}

            update_score(@home_id => @home_points.to_i) if @home_points
            update_score(@away_id => @away_points.to_i) if @away_points
            parse_score(data['scoring']) if data['scoring']
            @scoring_raw.update(data, source: source)

            create_data(@teams_hash, data['team'], klass: Team, api: api, game: self) if data['team']
          end

          def box
            @box ||= get_box
          end
          def pbp
            if !future? && quarters.empty?
              get_pbp
            end
            @pbp ||= quarters
          end
          def plays
            quarters.flat_map(&:plays)
          end
          def summary
            @summary ||= get_summary
          end
          alias :events :plays

          def quarters
            @quarters_hash.values
          end


          # tracking updates
          def remember(key, object)
            @updates[key] = object
          end
          def not_updated?(key, object)
            @updates[key] == object
          end
          def changed?(key)
            @changes[key]
          end
          def check_newness(key, new_object)
            @changes[key] = !not_updated?(key, new_object)
            remember(key, new_object)
          end

          # url paths
          def path_base
            "games/#{ id }"
          end
          def path_box
            "#{ path_base }/boxscore"
          end
          def path_pbp
            "#{ path_base }/pbp"
          end
          def path_summary
            "#{ path_base }/summary"
          end

          # status helpers
          def postponed?
            'postponed' == status
          end
          def future?
            ['scheduled', 'delayed', 'created'].include? status
          end
          def started?
            ['inprogress', 'halftime', 'delayed'].include? status
          end
          def finished?
            ['complete', 'closed'].include? status
          end
          def completed?
            'complete' == status
          end
          def closed?
            'closed' == status
          end

          # data retrieval
          def sync
            g.get_pbp
            g.get_box
            g.get_summary if finished?
          end

          def get_box
            api_res = api.get_data(path_box)
            data = api_res['game']
            update(data, source: :box)
            @quarter = data.delete('quarter').to_i
            check_newness(:box, @clock)
            data
          end

          def get_pbp
            api_res = api.get_data(path_pbp)
            data = api_res['game']
            update(data, source: :pbp)
            quarter_data = if data['quarter']
              @quarter = data['quarter'].first.to_i
              quarts = data['quarter'][1..-1]
              quarts.is_a?(Array) ? quarts[0] : quarts
            else
              @quarter = nil
              []
            end
            if data['overtime']
              extra_quarters = data['overtime'].is_a?(Hash) ? [data['overtime']] : data['overtime']
              quarter_data.concat(extra_quarters)
            end
            set_pbp(quarter_data)
            @pbp = @quarters_hash.values
            check_newness(:pbp, plays.last)
            data
          end

          def get_summary
            api_res = api.get_data(path_summary)
            data = api_res['game']
            update(data, source: :summary)
            @quarter = data.delete('quarter').to_i
            check_newness(:box, @clock)
            data
          end

          def set_pbp(data)
            create_data(@quarters_hash, data, klass: Quarter, api: api, game: self)
            @plays  = nil # to clear empty array empty
            @quarters_hash
          end

          def api
            @api || Sportradar::Api::Basketball::Nba.new
          end


          KEYS_PBP = ["xmlns", "id", "status", "coverage", "home_team", "away_team", "scheduled", "duration", "attendance", "lead_changes", "times_tied", "clock", "quarter", "scoring"]

          KEYS_BOX = ["xmlns", "id", "status", "coverage", "home_team", "away_team", "scheduled", "duration", "attendance", "lead_changes", "times_tied", "clock", "quarter", "team"]

        end
      end
    end
  end
end

__END__

ss = sr.schedule;
sr = Sportradar::Api::Basketball::Nba.new
sd = sr.daily_schedule;
sd = sr.daily_schedule(Date.yesterday)
g = sd.games.last;
box = g.get_box;
pbp = g.get_pbp;
g.quarters.size
g.plays.size

Sportradar::Api::Basketball::Nba::Team.all.size # => 32 - includes all star teams

g1 = sd.games.first;
sd = sr.schedule;
sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
sd = sr.daily_schedule(Date.yesterday);
g = sd.games.last;
g.get_summary;
g.get_pbp;
g.get_box;
g.scoring
g.get_pbp; g.changed? :pbp