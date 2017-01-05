module Sportradar
  module Api
    class Mma
      class Event < Data
        attr_accessor :response, :id, :name, :scheduled, :venue, :league

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @fights_hash = {}
          @updated_at = Time.now

          @id         = response['id']
          @name       = response['name']
          update(data)
        end

        def fights
          @fights_hash.values
        end

        def update(data)
          @scheduled  = Time.parse(data["scheduled"])                     if data["scheduled"]
          @venue      = Venue.new(data['venue'], event: self, api: api)   if data['venue']
          @league     = League.new(data['league'], event: self, api: api) if data['league']
          update_fights(data)

          self
        end

        def update_fights(data)
          return if String === data['fights']
          create_data(@fights_hash, data.dig('fights', 'fight'), klass: Fight, api: api, event: self)
        end


        def path_base
          "events/#{ id }"
        end
        def path_stats
          "#{ path_base }/summary"
        end
        # def path_pbp
        #   "#{ path_base }/pbp"
        # end

        def get_stats
          res = api.get_data(path_stats)
          data = res['summary']
          @updated_at = data['generated']
          update(data.dig('events', 'event'))
          res
        end

        def api
          @api ||= Sportradar::Api::Mma.new
        end


        # def get_pbp
        #   data = api.get_data(path_pbp)['game']
        #   update(data)
        #   @quarter = data['quarter'].first
        #   @pbp = set_pbp(data['quarter'][1..-1])
        # end

        # def set_pbp(data)
        #   @quarters = parse_into_array_with_options(selector: data, klass: self.parent::Quarter, api: api, game: self)
        #   @plays  = nil # to clear empty array empty
        #   @quarters
        # end

        KEYS_SCHED = ["id", "name", "scheduled", "venue", "league", "fights"]

      end
    end
  end
end

__END__

m = Sportradar::Api::Mma.new
sc = m.schedule;
e = sc.events.sample;
e = sc.events.first;
e = sc.events.last;



m = Sportradar::Api::Mma.new
sr = m.participants;
e = sc.events.sample;
f = sr.fighters.sample;
f.fights.size
sc = m.schedule;
f.fights.size
f.fights.first
f.fights.first.event


event_hash = {"id"=>"f7c80a91-c6e7-4636-a5ec-62e59ca0afab" }
e = Sportradar::Api::Mma::Event.new(event_hash)
e.get_stats;
e

event_hash = {"id"=>"8f85ecc5-0d4d-470b-b357-075cc7e7bedd" } # => UFC 205 - McGregor/Alvarez
e = Sportradar::Api::Mma::Event.new(event_hash)
res = e.get_stats;
f = e.fights.last.result
f.scores

