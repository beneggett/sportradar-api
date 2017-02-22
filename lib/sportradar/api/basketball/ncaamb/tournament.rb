module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Tournament < Data
          attr_accessor :response, :id, :name, :status, :location, :start, :end

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id       = data['id']

            @rounds_hash   = {}
            @brackets_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @response = data

            @season = opts[:season] if opts[:season]

            @status   = data['status']                  if data['status']
            @name     = data['name']                    if data['name']
            @location = data['location']                if data['location']
            @start    = Date.parse(data['start_date'])  if data['start_date']
            @end      = Date.parse(data['end_date'])    if data['end_date']
            @type     = data.dig('season', 'type')      if data.dig('season', 'type')
            @year     = @start&.year

            update_rounds(data['rounds'])     if data['rounds'] # switch to rounds
            update_brackets(data['brackets']) if data['brackets'] # switch to brackets
          end

          def games
            rounds.flat_map(&:games)
          end

          def year
            @season&.year || (@start&.-120)&.year
          end

          def rounds
            @rounds_hash.values
          end

          def brackets
            @brackets_hash.values
          end
          def bracket(id)
            @brackets_hash[id]
          end
          def update_bracket(id, data)
            if @brackets_hash[id]
              @brackets_hash[id].update(data)
            else
              @brackets_hash[id] = Bracket.new(data, tournament: self)
            end
          end
          def update_brackets(data)
            create_data(@brackets_hash, data, klass: Round, api: @api, tournament: self)
          end

          # switch to rounds
          # rounds are either bracketed (bracketed) or not (games)
          def update_rounds(data)
            create_data(@rounds_hash, data, klass: Round, api: @api, tournament: self)
          end

          # url paths
          def path_base
            "tournaments/#{ id }"
          end
          def path_schedule
            "#{ path_base }/schedule"
          end

          def path_summary
            "#{ path_base }/summary"
          end

          # data retrieval
          def sync
            get_summary
            get_schedule
          end

          # summary
          def get_summary
            data = api.get_data(path_summary)
            ingest_summary(data)
          end
          def queue_summary
            url, headers, options, timeout = api.get_request_info(path_summary)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_summary)}
          end
          def ingest_summary(data)
            update(data, source: :summary)
            data
          end

          # schedule
          def get_schedule
            data = api.get_data(path_schedule)
            ingest_schedule(data)
          end
          def queue_schedule
            url, headers, options, timeout = api.get_request_info(path_schedule)
            {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_schedule)}
          end
          def ingest_schedule(data)
            update(data, source: :schedule)
            data
          end

          def api
            @api ||= Sportradar::Api::Basketball::Ncaamb.new
          end

        end
      end
    end
  end
end

__END__

sr = Sportradar::Api::Basketball::Ncaamb.new
ss = sr.tournaments(2015);
ss = sr.conference_tournaments(2015);
ts = sr.conference_tournaments;
ts = sr.tournaments;
t = ss.tournament("608152a4-cccc-4569-83ac-27062580099e") # => NCAA tourney 2015
t = ts.tournament("74db39e5-be49-4ec8-9169-0cc20ed9f792") # => NCAA tourney 2016
tt = Sportradar::Api::Basketball::Ncaamb::Tournament.new('id' => "608152a4-cccc-4569-83ac-27062580099e") # => NCAA tourney 2015
t = ss.tournament("1a4a1d3d-b734-4136-a7c2-711b4b3821a5") # => Pac12 tourney 2015
t = Sportradar::Api::Basketball::Ncaamb::Tournament.new('id' => "1a4a1d3d-b734-4136-a7c2-711b4b3821a5") # => NCAA tourney 2015
t = ts.first
