module Sportradar
  module Api
    module Football
      class Quarter < Data
        attr_accessor :response, :api, :id, :number, :sequence, :home_points, :away_points, :drives, :scoring

        def initialize(data, **opts)
          @response = data
          @id = data["number"]
          @api = opts[:api]

          update(data, **opts)
        end

        def update(data, **opts)
          @number       = data["number"]
          @sequence     = data["sequence"]
          @home_points  = data["home_points"]
          @away_points  = data["away_points"]

          @home_info = data["home"]
          @away_info = data["away"]

          create_data(@drives_hash, data['pbp'], klass: Drive, api: api, game: self) if data['pbp']

          self
        end

      end

      # class QuarterScoring < Data
      #   attr_accessor :home, :away
      #   def initialize(data)
      #     @home = OpenStruct.new(data['home'])
      #     @away = OpenStruct.new(data['away'])
      #   end
      # end
    end
  end
end
