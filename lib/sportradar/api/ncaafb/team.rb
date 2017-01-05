module Sportradar
  module Api
    class Ncaafb
      class Team < Data
        attr_accessor :response, :id, :name, :market

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          case response
          when String
            @id = response
          when Hash
            @id = data['id']
            update(response)
          end
        end
        def full_name
          (market || name) ? [market, name].join(' ') : id
        end
        def update(data)
          @name     = data['name']                  if data['name']
          @market   = data['market']                if data['market']
          @players  = parse_players(data['player']) if data['player']
        end

        def players
          @players ||= get_roster
        end
        alias :roster :players
        def parse_players(data)
          @players = parse_into_array_with_options(selector: data, klass: Sportradar::Api::Ncaafb::Player, api: api, team: self)
        end

        def get_roster
          data = api.get_data(path_roster)['team']
          update(data)
        end

        def path_base
          "teams/#{ id }"
        end
        def path_roster
          "#{ path_base }/roster"
        end


        def api
          @api || Sportradar::Api::Ncaafb.new
        end

      end
    end
  end
end

__END__

sr = Sportradar::Api::Ncaafb.new;
ss = sr.schedule;
teams = ss.weeks(1).games.flat_map(&:teams);
t = teams.first;
ps = t.get_roster; # ps => players


# week_count = ss.weeks.count;
# w1 = ss.weeks.first;
# w1 = ss.weeks(1);
