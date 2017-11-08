module Sportradar
  module Api
    module Soccer
      class Player < Data

        attr_reader :id, :league_group, :name, :type, :nationality, :country_code, :height, :weight, :jersey_number, :preferred_foot, :stats, :date_of_birth, :matches_played
        alias :position :type

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id'] if data['id']
          @api          = opts[:api]
          @league_group = league_group || data['league_group'] || @api&.league_group

          update(data, **opts)
        end

        def update(data, **opts)
          @id             = data['id']             if data['id']
          @league_group = opts[:league_group] || data['league_group'] || @league_group

          if data['player']
            update(data['player'])
          end

          @name           = data['name']           if data['name']
          @last_name      = data['last_name']      if data['last_name']
          @first_name     = data['first_name']     if data['first_name']
          @type           = data['type']           if data['type']
          @nationality    = data['nationality']    if data['nationality']
          @country_code   = data['country_code']   if data['country_code']
          @height         = data['height']         if data['height']
          @weight         = data['weight']         if data['weight']
          @jersey_number  = data['jersey_number']  if data['jersey_number']
          @preferred_foot = data['preferred_foot'] if data['preferred_foot']
          @matches_played = data['matches_played'] if data['matches_played']

          @stats          = data['statistics']     if data['statistics']

          @date_of_birth  = Date.parse(data['date_of_birth']) if data['date_of_birth']
        end

        def display_name
          @name || [@first_name, @last_name].join(' ')
        end

        def first_name
          @first_name || (@name && @name.split(', ')[1])
        end

        def last_name
          @last_name || (@name && @name.split(', ')[0])
        end

        def api
          @api || Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def path_base
          "players/#{ id }"
        end

        def path_profile
          "#{ path_base }/profile"
        end
        def get_profile
          data = api.get_data(path_profile).to_h
          ingest_profile(data)
        end
        def ingest_profile(data)
          update(data)
          data
        end
        def queue_profile
          url, headers, options, timeout = api.get_request_info(path_profile)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_profile)}
        end
      end
    end
  end
end
