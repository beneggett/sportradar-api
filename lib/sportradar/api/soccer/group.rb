module Sportradar
  module Api
    module Soccer
      class Group < Data
        attr_reader :league_group

        def initialize(data = {}, league_group: nil, **opts)
          @id = data['id']

          @league_group = league_group || data['league_group']

          @tournaments_hash = {}
          # @daily_schedule   = {}

          update(data, **opts)
        end

        def update(data, **opts)
          create_data(@tournaments_hash, data['tournaments'], klass: Tournament, api: api, league_group: @league_group) if data['tournaments']
        end

        def tournaments
          @tournaments_hash.values
        end


        def api
          @api ||= Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def get_tournaments
          data = api.get_data(path_tournaments).to_h
          ingest_tournaments(data)
        end

        def ingest_tournaments(data)
          update(data, source: :tournaments)
          data
        end

        def queue_tournaments
          url, headers, options, timeout = api.get_request_info(path_tournaments)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_tournaments)}
        end

        def path_tournaments
          'tournaments'
        end

        def self.europe
          self.new(league_group: 'eu')
        end
        def self.americas
          self.new(league_group: 'am')
        end
        def self.north_america
          self.new(league_group: 'na')
        end

        def self.international
          self.new(league_group: 'intl')
        end

      end
    end
  end
end
