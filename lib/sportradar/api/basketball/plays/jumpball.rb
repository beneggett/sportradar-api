module Sportradar
  module Api
    module Basketball
      class Jumpball < Play::Base
        alias :winner :team_id
      end
    end
  end
end
