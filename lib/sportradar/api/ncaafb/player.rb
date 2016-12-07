module Sportradar
  module Api
    class Ncaafb
      class Player < Data
        attr_accessor :response, :id, :name, :name_abbr, :birthdate, :height, :weight, :position, :jersey_number, :status

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @team     = opts[:team]

          # case response
          # when String
          #   @id = response
          # when Hash
          #   @id = data['id']
          #   update(response)
          # end

          @id            = response['id']             # => "83aa1cc4-9e79-432f-9178-6583fc1cc598",
          @name_full     = response['name_full']      # => "Raymond Davison",
          @name_first    = response['name_first']     # => "Raymond",
          @name_last     = response['name_last']      # => "Davison",
          @name_abbr     = response['name_abbr']      # => "R.Davison",
          @birthdate     = response['birthdate']      # => "",
          @height        = response['height']         # => "74",
          @weight        = response['weight']         # => "225",
          @position      = response['position']       # => "LB",
          @jersey_number = response['jersey_number']  # => "31",
          @status        = response['status']         # => "ACT",
        end
        def full_name
          # (market || name) ? [market, name].join(' ') : id
          name_full || [name_first, name_last].join(' ')
        end
        def update(data)
          @name_full     = data['name_full']      if data['name_full']
          @name_first    = data['name_first']     if data['name_first']
          @name_last     = data['name_last']      if data['name_last']
          @name_abbr     = data['name_abbr']      if data['name_abbr']
          @birthdate     = data['birthdate']      if data['birthdate']
          @height        = data['height']         if data['height']
          @weight        = data['weight']         if data['weight']
          @position      = data['position']       if data['position']
          @jersey_number = data['jersey_number']  if data['jersey_number']
          @status        = data['status']         if data['status']
        end
        def parse_players(data)
          # @players = parse_into_array_with_options(data)
          # data
        end


        def api
          @api || Sportradar::Api::Ncaafb.new
        end

      end
    end
  end
end
