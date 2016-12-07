module Sportradar
  module Api
    class Mma
      class Venue < Data
        attr_accessor :response, :id, :event, :name, :country_code, :country, :state, :city
        @all_hash = {}
        def self.new(data, **opts)
          existing = @all_hash[data['name']]
          if existing
            existing.update(data)
            existing.add_event(opts[:event])
            existing
          else
            @all_hash[data['name']] = super
          end
        end
        def self.all
          @all_hash.values
        end

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @event    = opts[:event]
          @events_hash = {}

          @id       = data['id']

          update(data)
        end

        def events
          @events_hash.values
        end
        def add_event(event)
          @events_hash[event.id] = event if event
        end

        def update(data, **opts)
          @name         = data['name']
          @country_code = data['country_code']
          @country      = data['country']
          @state        = data['state']
          @city         = data['city']

          @id         = @name + ', ' + @city

          self
        end

        def add_event(event)
          @events << event if event
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
sc.events.size
e = sc.events.last;
e.venue.events.size
