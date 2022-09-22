module Sportradar
  module Api
    module Mma
      class Roster < Data
        attr_accessor :response, :id, :name, :scheduled, :venue

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]

          @generated = response['generated']

          @fighters_hash = {}
          @referees_hash = {}
          @judges_hash   = {}

          update(data)
        end

        def fighters
          @fighters_hash ||= update_fighters(response)
          @fighters_hash.values
        end
        def referees
          @referees_hash ||= update_referees(response)
          @referees_hash.values
        end
        def judges
          @judges_hash ||= update_judges(response)
          @judges_hash.values
        end

        def update(data)
          # update_fighters(data)
          # update_referees(data)
          # update_judges(data)

          self
        end

        def update_fighters(data)
          create_data(@fighters_hash, response.dig('fighters', 'fighter'), klass: Fighter, api: api, roster: self)
        end
        def update_referees(data)
          create_data(@referees_hash, response.dig('referees', 'referee'), klass: Referee, api: api, roster: self)
        end
        def update_judges(data)
          create_data(@judges_hash, response.dig('judges', 'judge'), klass: Judge, api: api, roster: self)
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


sc = m.schedule;
sc.events.size
e = sc.events.last;
e.venue.events.size

Sportradar::Api::Mma::Schedule.new({}, api: m)
Sportradar::Api::Mma::Schedule.new

