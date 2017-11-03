module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Half < Data
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
            create_data(@plays_hash, data.dig('events'), klass: Play, api: @api, half: self)
          end

          def plays_by_type(play_type, *types)
            if types.empty?
              plays.grep(Play.subclass(play_type.delete('_')))
            else
              play_classes = [play_type, *types].map { |type| Play.subclass(type.delete('_')) }
              plays.select { |play| play_classes.any? { |klass| play.kind_of?(klass) } }
            end
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
