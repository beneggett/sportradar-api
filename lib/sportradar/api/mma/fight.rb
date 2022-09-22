module Sportradar
  module Api
    module Mma
      class Fight < Data
        attr_accessor :response, :id, :season, :start_time, :start_time_confirmed, :sport_event_context, :coverage, :venue, :status, :match_status, :winner_id, :final_round, :final_round_length, :end_method, :winner, :scheduled_length, :weight_class, :title_fight

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @season    = opts[:season]
          @fighters_hash = {}

          @id       = data['id']
          @statistics = {}

          update(data)
        end

        def fighters
          @fighters_hash.values
        end

        def update(data, **opts)
          if data["sport_event"]
            update(data["sport_event"])
          end
          if data["sport_event_status"]
            update(data["sport_event_status"])
          end

          @id                   = data['id'] if data['id'] && !@id
          @start_time           = Time.parse(data['start_time'])  if data['start_time']
          @start_time_confirmed = data['start_time_confirmed']    if data['start_time_confirmed']
          @sport_event_context  = data['sport_event_context']     if data['sport_event_context']
          @coverage             = data['coverage']                if data['coverage']
          @venue                = data['venue']                   if data['venue']

          @status             = data['status']                    if data['status']
          @match_status       = data['match_status']              if data['match_status']
          @winner_id          = data['winner_id']                 if data['winner_id']
          @final_round        = data['final_round']               if data['final_round']
          @final_round_length = data['final_round_length']        if data['final_round_length']
          @end_method         = data['method']                    if data['method']
          @winner             = data['winner']                    if data['winner']
          @scheduled_length   = data['scheduled_length']          if data['scheduled_length']
          @weight_class       = data['weight_class']              if data['weight_class']
          @title_fight        = data['title_fight']               if data['title_fight']


          update_fighters(data) if data['competitors']

          self
        end

        def season_id
          @season&.id || @sport_event_context&.dig('season', 'id')
        end

        def starts_at
          @start_time
        end

        def coverage_level
          'live' if @coverage&.dig('live')
        end

        def title
          fighters.map(&:display_name).join(' vs ')
        end

        def scheduled
          @start_time
        end

        def update_fighters(data)
          if data['competitors']
            create_data(@fighters_hash, data['competitors'], klass: Fighter, api: api, fight: self)
          end
        end
        def api
          @api ||= Sportradar::Api::Mma.new
        end


        def path_base
          "sport_events/#{ id }"
        end

        def path_summary
          "#{ path_base }/summary"
        end

        def get_summary
          data = api.get_data(path_summary)
          update(data)

          data
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
sc.events.size;
e = sc.events.sample;
e = sc.events.first;
e = sc.events.last;
e.venue.events.size
