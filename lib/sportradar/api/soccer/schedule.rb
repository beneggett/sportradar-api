module Sportradar
  module Api
    class Soccer::Schedule < Data
      attr_accessor :response, :matches

      def initialize(data)
        @response = data
        set_matches
      end

      def league(league_name)
        matches.select{ |match| match.tournament_group.name.parameterize == league_name.parameterize}
      end

      def available_leagues
        matches.map {|match| match.tournament_group.name}.uniq
      end

      private
      def set_matches
        if response["schedule"]["matches"]["match"]
          if response["schedule"]["matches"]["match"].is_a?(Array)
            @matches = response["schedule"]["matches"]["match"].map {|x| Sportradar::Api::Soccer::Match.new x }
          elsif response["schedule"]["matches"]["match"].is_a?(Hash)
            @matches = [ Sportradar::Api::Soccer::Match.new(response["schedule"]["matches"]["match"]) ]
          end
        end
      end

    end
  end
end
