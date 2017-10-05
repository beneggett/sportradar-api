module Sportradar
  module Api
    class Soccer::Player < Data

      attr_accessor :id, :first_name, :last_name, :country_code, :country, :reference_id, :full_first_name, :full_last_name, :position, :started, :jersey_number, :tactical_position, :tactical_order, :statistics, :preferred_foot, :birthdate, :height_in, :weight_lb, :height_cm, :weight_kg, :teams, :response, :rank, :total, :statistics, :last_modified

      def initialize(data)
        @response = data
        @teams = parse_into_array(selector: response["team"], klass: Sportradar::Api::Soccer::Team)  if response["team"]
        @teams = parse_into_array(selector: response["teams"]["team"], klass: Sportradar::Api::Soccer::Team)  if response["teams"] && response["teams"]["team"]
        @id = data["id"]
        @first_name = data["first_name"]
        @last_name = data["last_name"]
        @country_code = data["country_code"]
        @country = data["country"]
        @reference_id = data["reference_id"]
        @full_first_name = data["full_first_name"]
        @full_last_name = data["full_last_name"]
        @position = data["position"] || primary_team.try(:position)
        @started = data["started"]
        @jersey_number = data["jersey_number"] || primary_team.try(:jersey_number)
        @tactical_position = data["tactical_position"]
        @tactical_order = data["tactical_order"]
        @last_modified = data["last_modified"]

        # profile
        @preferred_foot = data["preferred_foot"]
        @birthdate = data["birthdate"]
        @height_in = data["height_in"]
        @weight_lb = data["weight_lb"]
        @height_cm = data["height_cm"]
        @weight_kg = data["weight_kg"]
        @rank = data["rank"]
        @total = OpenStruct.new data["total"] if data["total"]
        @statistics = parse_into_array(selector:response["statistics"]["season"], klass: Sportradar::Api::Soccer::Season)  if response["statistics"] &&  response["statistics"]["season"]

      end

      def name
        [first_name, last_name].join(' ')
      end

      def full_name
        full = [full_first_name, full_last_name].join(' ')
        full == " " ? name : full
      end

      def position_name
        positions = {"G" => "Goalie", "D" => "Defender", "M" => "Midfielder", "F" => "Forward", "" => "N/A"}
        if position
          positions[position]
        elsif primary_team.present?
          positions[primary_team.position]
        end
      end

      def primary_team
        if teams.count == 1
          teams.first
        else
          teams.find {|team| team.name != team.country_code}
        end if teams
      end


      def tactical_position_name
        tactical_positions = { "0" => "Unknown", "1" => "Goalkeeper", "2" => "Right Back", "3" => "Central Defender", "4" => "Left Back", "5" => "Right winger", "6" => "Central Midfielder", "7" => "Left Winger", "8" => "Forward" }
        tactical_positions[tactical_position] if tactical_position
      end

      def age
        if birthdate.present?
          now = Time.now.utc.to_date
          dob = birthdate.to_date
          now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
        end
      end

      def height_ft
        if height_in.present?
          feet, inches = height_in.to_i.divmod(12)
          "#{feet}' #{inches}\""
        end
      end

    end
  end
end
