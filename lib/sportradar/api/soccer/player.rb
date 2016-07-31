module Sportradar
  module Api
    class Soccer::Player < Data

      attr_accessor :id, :first_name, :last_name, :country_code, :country, :reference_id, :full_first_name, :full_last_name, :position, :started, :jersey_number, :tactical_position, :tactical_order, :statistics, :preferred_foot, :birthdate, :height_in, :weight_lb, :height_cm, :weight_kg, :teams, :response, :rank, :total, :statistics, :last_modified

      def initialize(data)
        @response = data
        set_teams
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

        set_statistics
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
        tactical_positions = { "0" => "Unknown", "1" => "Goalkeeper", "2" => "Right back", "3" => "Central defender", "4" => "Left back", "5" => "Right winger", "6" => "Central midfielder", "7" => "Left winger", "8" => "Forward" }
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

      private

      def set_teams
        if response["team"]
          if response["team"].is_a?(Array)
            @teams = response["team"].map {|team| Sportradar::Api::Soccer::Team.new team }
          elsif response["team"].is_a?(Hash)
            @teams = [ Sportradar::Api::Soccer::Team.new(response["team"]) ]
          end
        elsif response["teams"] && response["teams"]["team"]
          if response["teams"]["team"].is_a?(Array)
            @teams = response["teams"]["team"].map {|team| Sportradar::Api::Soccer::Team.new team }
          elsif response["teams"]["team"].is_a?(Hash)
            @teams = [ Sportradar::Api::Soccer::Team.new(response["teams"]["team"]) ]
          end
        end
      end

      def set_statistics
        if response["statistics"] && response["statistics"]["season"]
          if response["statistics"]["season"].is_a?(Array)
            @statistics = response["statistics"]["season"].map {|statistic| Sportradar::Api::Soccer::Season.new statistic }
          elsif response["statistics"]["season"].is_a?(Hash)
            @statistics = [ Sportradar::Api::Soccer::Season.new(response["statistics"]["season"]) ]
          end
        end
      end

    end
  end
end
