module Sportradar
  module Api
    class Soccer::Schedule < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        @matches = data["schedule"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x } if data["schedule"]["matches"]["match"]
      end

      def league(league_name)
        matches.select{ |match| match.tournament_group.name.parameterize == league_name.parameterize}
      end

      def available_leagues
        matches.map {|match| match.tournament_group.name}.uniq
      end


    end
  end
end
