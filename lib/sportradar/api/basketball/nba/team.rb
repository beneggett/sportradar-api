module Sportradar
  module Api
    module Basketball
      class Nba
        class Team < Sportradar::Api::Basketball::Team


          @all_hash = {}
          def self.new(data, **opts)
            existing = @all_hash[data['id']]
            if existing
              existing.update(data, **opts)
              existing
            else
              # unless data['id']
              #   data.merge!(data.delete('team')) if data['team']
              # end
              @all_hash[data['id']] = super
            end
          end
          def self.all
            @all_hash.values
          end

          def player_class
            Player
          end

          def api
            @api || Sportradar::Api::Basketball::Nba::Api.new
          end

          def handle_names(data)
            # need to do some more work here
            @name = data['name'] if data['name']
            if data['name'] && !data.key?('market')
              @full_name = data['name']
              if @full_name.split.size > 1
                if @full_name.include? 'Blazers'
                  @market = 'Portland'
                  @name = 'Trail Blazers'
                  @full_name = 'Portland Trail Blazers'
                else
                  @market = @full_name.split[0..-2].join(' ')
                  @name = @full_name.split.last
                end
              end
            elsif data['name'] && data['market']
              @market = data['market']
              @full_name = [@market, data['name']].join(' ')
            end
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