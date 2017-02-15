module Sportradar
  module Api
    module Basketball
      class Nba
        class Quarter < Data
          attr_accessor :response, :id, :game, :number, :sequence, :home_points, :away_points, :drives
          # @all_hash = {}
          # def self.new(data, **opts)
          #   existing = @all_hash[data['id']]
          #   if existing
          #     existing.update(data, **opts)
          #     existing
          #   else
          #     @all_hash[data['id']] = super
          #   end
          # end
          # def self.all
          #   @all_hash.values
          # end

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]
            # @game     = opts[:game]

            @id       = response["id"]
            @number   = response['number']
            @sequence = response['sequence']

            @plays_hash = {}

            update(data)
          end
          def update(data, **opts)
            create_data(@plays_hash, data.dig('events'), klass: Play, api: @api, quarter: self)
          # rescue => e
          #   binding.pry
          end

          def plays
            @plays_hash.values
          end
          alias :events :plays

          private

        end
      end
    end
  end
end
