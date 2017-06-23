module Sportradar
  module Api
    module Football
      class Nfl
        class Quarter < Sportradar::Api::Football::Quarter

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

          # def drive_class
          #   Quarter
          # end
        end
      end
    end
  end
end
