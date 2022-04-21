require_relative 'soccer/api'
require_relative 'soccer/group'
require_relative 'soccer/tournament'
require_relative 'soccer/competition'
require_relative 'soccer/standing'
require_relative 'soccer/team_group'
require_relative 'soccer/season'
require_relative 'soccer/match'
require_relative 'soccer/event'
require_relative 'soccer/lineup'
require_relative 'soccer/team'
require_relative 'soccer/player'
require_relative 'soccer/venue'
require_relative 'soccer/fact'
require_relative 'soccer/scoring'

module Sportradar
  module Api
    module Soccer
      
      def self.parse_results(arr)
        arr.map { |hash| hash["sport_event"].merge(hash["sport_event_status"]) }
      end

      def self.get_competitions
        data = api.get_data(path_competitions).to_h
        parse_competitions(data)
      end

      def self.parse_competitions(data)
        if data['competitions']
          data['competitions'].map do |hash|
            Competition.new(hash, api: api)
          end
        end
      end

      def self.api
        @api ||= Sportradar::Api::Soccer::Api.new
      end

      # url path helpers
      def self.path_competitions
        "competitions"
      end

    end
  end
end

__END__

comps = Sportradar::Api::Soccer.get_competitions;
comp = comps.detect { |comp| comp.id == 'sr:competition:27466' }
comp = comps.third;
comp.get_seasons;
season = comp.seasons.last;
resp = season.get_schedule;
season.matches.size;
match = season.matches.first;
data = match.get_summary
