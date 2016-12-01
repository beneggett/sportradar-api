module Sportradar
  module Api
    class Nfl::Player < Data
      attr_accessor :response, :id, :sequence, :title, :game, :full_name, :jersey, :reference, :position, :depth, :injury, :age, :birth_date, :birth_place, :college, :college_conf, :draft, :first_name, :height, :high_school, :last_name, :preferred_name, :references, :rookie_year, :status, :weight, :abbr_name, :seasons, :team

      def initialize(data)
        data = [data].to_h if data.is_a? Array # for kickers in depth charts
        @response = data
        @depth = data["depth"]
        @game = data["game"] # Games
        @id = data["id"]
        @jersey = data["jersey"]
        @full_name = data["name"]
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
        @seasons = parse_into_array(selector: response["season"], klass: Sportradar::Api::Nfl::Season)  if response["season"]
      end
      def name
        @name ||= [(preferred_name || first_name), last_name].join(' ')
      end

      def age
        if birth_date.present?
          now = Time.now.utc.to_date
          dob = birth_date.to_date
          now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
        end
      end

    end
  end
end
