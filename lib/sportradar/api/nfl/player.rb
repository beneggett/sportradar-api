module Sportradar
  module Api
    class Nfl::Player < Data
      attr_accessor :response, :id, :sequence, :title, :game, :name, :jersey, :reference, :position, :depth, :injury, :age, :birth_date, :birth_place, :college, :college_conf, :draft, :first_name, :height, :high_school, :last_name, :preferred_name, :references, :rookie_year, :status, :weight, :abbr_name, :seasons, :team

      def initialize(data)
        @response = data
        @depth = data["depth"]
        @game = data["game"] # Games
        @id = data["id"]
        @jersey = data["jersey"]
        @name = data["name"]
        @position = data["position"]
        @reference = data["reference"]
        @sequence = data["sequence"]
        @title = data["title"]
        @age = data["age"]
        @birth_date = data["birth_date"]
        @birth_place = data["birth_place"]
        @college = data["college"]
        @college_conf = data["college_conf"]
        @first_name = data["first_name"]
        @height = data["height"]
        @high_school = data["high_school"]
        @last_name = data["last_name"]
        @preferred_name = data["preferred_name"]
        @references = data["references"]
        @rookie_year = data["rookie_year"]
        @status = data["status"]
        @weight = data["weight"]
        @abbr_name = data["abbr_name"]
        @team = Sportradar::Api::Nfl::Team.new data["team"] if data["team"]
        @injury = Sportradar::Api::Nfl::Injury.new data["injury"] if data["injury"]
        @draft = Sportradar::Api::Nfl::Draft.new data["draft"] if data["draft"]
        set_seasons
      end

      private

      def set_seasons
        if response["season"]
          if response["season"].is_a?(Array)
            @seasons = response["season"].map {|season| Sportradar::Api::Nfl::Season.new season }
          elsif response["season"].is_a?(Hash)
            @seasons = [ Sportradar::Api::Nfl::Season.new(response["season"]) ]
          end
        end
      end

    end
  end
end
