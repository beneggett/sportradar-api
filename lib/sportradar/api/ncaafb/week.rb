module Sportradar
  module Api
    class Ncaafb
      class Week < Data
        attr_accessor :response, :id, :sequence, :title, :season

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @season   = opts[:season]
          # @id       = response['id']
          # @year     = response['year']
          # @type     = response['type']
          @sequence = response['week']

        rescue => e
          binding.pry
        end

        def number
          sequence
        end

        # private

        def games
          @games ||= parse_into_array_with_options(selector: response["game"], klass: Sportradar::Api::Ncaafb::Game, api: @api, week: self)
        end

      end
    end
  end
end
