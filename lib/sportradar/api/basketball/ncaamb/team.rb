module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Team < Sportradar::Api::Basketball::Team
          attr_accessor :source, :source_id

          @all_hash = {}
          def self.new(data, **opts)
            existing = @all_hash[data['id']]
            if existing
              existing.update(data, **opts)
              existing
            else
              if data['id']
                @all_hash[data['id']] = super
              else # tournament placeholder
                super.tap do |team|
                  team.source = data['source']
                  team.source_id = data.dig('source', 'id')
                end
              end
            end
          end
          def self.all
            @all_hash.values
          end

          def player_class
            Player
          end

          def api
            @api || Sportradar::Api::Basketball::Ncaamb::Api.new
          end

          def good_guys?
            id == "9b166a3f-e64b-4825-bb6b-92c6f0418263"
          end

        end
      end
    end
  end
end

__END__
ss = sr.schedule;
sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
lh = sr.league_hierarchy;
t = lh.teams.first;
ss = t.get_season_stats;
g = sd.games.last;
t = g.home;
Sportradar::Api::Basketball::Nba::Team.all.size


# week_count = ss.weeks.count;
# w1 = ss.weeks.first;
# w1 = ss.weeks(1);