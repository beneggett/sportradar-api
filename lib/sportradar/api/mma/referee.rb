module Sportradar
  module Api
    module Mma
      class Referee < Data
        attr_accessor :response, :id, :first_name, :last_name
        @all_hash = {}
        def self.new(data, **opts)
          existing = @all_hash[data['id']]
          if existing
            existing.update(data, **opts)
            existing.add_fight(opts[:fight])
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
          @roster   = opts[:roster]
          @fights_hash = {}

          @id       = data['id']

          update(data)
        end

        def fights
          @fights_hash.values
        end
        def add_fight(fight)
          @fights_hash[fight.id] = fight if fight
        end


        def update(data, **opts)
          @first_name = data['first_name'] if data['first_name'] # "Sai",
          @last_name  = data['last_name']  if data['last_name']  # "The Boss",

          self
        end

        def api
          @api ||= Sportradar::Api::Mma.new
        end

      end
    end
  end
end

__END__


m = Sportradar::Api::Mma.new
sr = m.participants;
f = sr.fighters.sample;


m = Sportradar::Api::Mma.new
sc = m.schedule;
e = sc.events.sample;
e.fights.first.fighters.first.born

fighter_hash = {'id' => "259117dc-c443-4086-8c1d-abd082e3d4b9" } # => Conor McGregor
f = Sportradar::Api::Mma::Fighter.new(fighter_hash)
