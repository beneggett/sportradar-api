require_relative 'soccer/api'
require_relative 'soccer/group'
require_relative 'soccer/tournament'
require_relative 'soccer/standing'
require_relative 'soccer/season'
require_relative 'soccer/match'
require_relative 'soccer/event'
require_relative 'soccer/lineup'
require_relative 'soccer/team'
require_relative 'soccer/player'
require_relative 'soccer/venue'
require_relative 'soccer/fact'

module Sportradar
  module Api
    module Soccer
      
      def self.parse_results(arr)
        arr.map { |hash| hash["sport_event"].merge(hash["sport_event_status"]) }
      end
    end
  end
end
