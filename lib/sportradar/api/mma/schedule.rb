module Sportradar
  module Api
    module Mma
      class Schedule < Data
        attr_accessor :response, :id, :name, :scheduled, :venue

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @generated   = response['generated']
          @events_hash = {}
          update(data)
        end

        def events
          @events_hash ||= update_events(response)
          @events_hash.values
        end

        def update(data)
          update_events(data)

          self
        end

        def update_events(data)
          create_data(@events_hash, response.dig('events', 'event'), klass: Event, api: api, schedule: self)
        end
        def api
          @api ||= Sportradar::Api::Mma.new
        end


        KEYS_SCHED = ["id", "name", "scheduled", "venue", "league", "fights"]

      end
    end
  end
end

__END__

m = Sportradar::Api::Mma.new
sc = m.schedule;
se = m.events;
sc.events.size
e = sc.events.last;
e.venue.events.size

Sportradar::Api::Mma::Schedule.new({}, api: m)
Sportradar::Api::Mma::Schedule.new

