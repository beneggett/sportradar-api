require_relative "mma/api"
require_relative "mma/competition"
require_relative "mma/season"
require_relative "mma/schedule"
require_relative "mma/roster"
require_relative "mma/fighter"
require_relative "mma/event"
require_relative "mma/fight"
require_relative "mma/judge"
require_relative "mma/referee"
require_relative "mma/result"
require_relative "mma/score"
require_relative "mma/venue"
require_relative "mma/league"

module Sportradar
  module Api
    module Mma

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

      # url path helpers
      def self.path_competitions
        "competitions"
      end

      def self.get_seasons
        data = api.get_data(path_seasons).to_h
        parse_seasons(data)
      end

      def self.parse_seasons(data)
        if data['seasons']
          data['seasons'].map do |hash|
            Season.new(hash, api: api)
          end
        end
      end

      # url path helpers
      def self.path_seasons
        "seasons"
      end

      def self.api
        @api ||= Sportradar::Api::Mma::Api.new
      end

    end
  end
end

__END__

comps = Sportradar::Api::Mma.get_competitions;
comp = comps.first
comp.get_seasons
sea = comp.seasons.first

seasons = Sportradar::Api::Mma.get_seasons
sea = seasons.detect { |s| s.id == "sr:season:94429" }
sea.get_competitors
sea.get_summary
fight = sea.fights.detect { |f| f.id == "sr:sport_event:34102625" }
fight.title
