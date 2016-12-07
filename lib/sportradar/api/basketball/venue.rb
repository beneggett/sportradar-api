module Sportradar
  module Api
    module Basketball
      class Venue < Data
        attr_accessor :response, :id, :name, :address, :city, :state, :country, :zip, :capacity
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
          @id       = data["id"]

          update(data, **opts)
        end
        def update(data, **opts)
          @name     = data['name']
          @address  = data['address']
          @city     = data['city']
          @state    = data['state']
          @zip      = data['zip']
          @country  = data['country']
          @capacity = data['capacity']
        end

        def location
          "#{name}, #{city}"
        end

        KEYS_SCHEDULE = ["id", "name", "capacity", "address", "city", "state", "zip", "country"]
      end
    end
  end
end

__END__

sr = Sportradar::Api::Nba.new
lh = sr.league_hierarchy;
t = lh.teams.first;
t.venue.id
t.venue.name
t.venue.city
