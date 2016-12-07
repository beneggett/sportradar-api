module Sportradar
  module Api
    module Basketball
      class Bio < Data
        attr_accessor :player, :name

        def initialize(player)
          # @player       = player
          @id               = player.id
          @status           = player.status
          @full_name        = player.full_name
          @first_name       = player.first_name
          @last_name        = player.last_name
          @abbr_name        = player.abbr_name
          @height           = player.height
          @weight           = player.weight
          @position         = player.position
          @primary_position = player.primary_position
          @jersey_number    = player.jersey_number
          @experience       = player.experience
          @college          = player.college
          @birth_place      = player.birth_place
          @birthdate        = player.birthdate
        end

      end
    end
  end
end

__END__

sr = Sportradar::Api::Nba.new
