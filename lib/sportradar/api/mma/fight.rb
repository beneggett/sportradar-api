module Sportradar
  module Api
    class Mma
      class Fight < Data
        attr_accessor :response, :id, :event, :accolade, :scheduled_rounds, :weight_class, :result
        @all_hash = {}
        def self.new(data, **opts)
          existing = @all_hash[data['id']]
          if existing
            existing.update(data)
            # existing.add_event(opts[:event])
            # existing
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
          @event    = opts[:event]
          @fighters_hash = {}

          @id       = data['id']

          update(data)
        end

        def fighters
          @fighters_hash ||= update_fighters(response)
          @fighters_hash.values
        end

        def score
          result.scores
        end

        def update(data, **opts)
          @accolade         = data['accolade']         if data['accolade']
          @scheduled_rounds = data['scheduled_rounds'] if data['scheduled_rounds'] # "3",
          @weight_class     = data['weight_class']     if data['weight_class'] # {"id"=>"LW", "weight"=>"146-155", "description"=>"Lightweight"},

          @referee = Referee.new(data['referee'], fight: self, api: api) if data['referee']
          @result = Result.new(data['result'], fight: self, api: api) if data['result']

          update_fighters(data) if data['fighters']

          self
        end

        def update_fighters(data)
          create_data(@fighters_hash, response.dig('fighters', 'fighter'), klass: Fighter, api: api, fight: self)
        end
        def api
          @api ||= Sportradar::Api::Mma.new
        end


        # def path_base
        #   "games/#{ id }"
        # end
        # def path_box
        #   "#{ path_base }/boxscore"
        # end
        # def path_pbp
        #   "#{ path_base }/pbp"
        # end

        # def get_box
        #   data = api.get_data(path_box)['game']
        #   update(data)
        #   @quarter = data.delete('quarter')
        #   data
        # end

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
sc.events.size;
e = sc.events.sample;
e = sc.events.first;
e = sc.events.last;
e.venue.events.size
