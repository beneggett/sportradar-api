module Sportradar
  module Api
    class Soccer::Player

      attr_accessor :id, :first_name, :last_name, :country_code, :country, :reference_id, :full_first_name, :full_last_name, :position, :started, :jersey_number, :tactical_position, :tactical_order, :statistics, :preferred_foot, :birthdate, :height_in, :weight_lb, :height_cm, :weight_kg, :teams, :response


      def initialize(data)
        @id = data["id"]
        @first_name = data["first_name"]
        @last_name = data["last_name"]
        @country_code = data["country_code"]
        @country = data["country"]
        @reference_id = data["reference_id"]
        @full_first_name = data["full_first_name"]
        @full_last_name = data["full_last_name"]
        @position = data["position"]
        @started = data["started"]
        @jersey_number = data["jersey_number"]
        @tactical_position = data["tactical_position"]
        @tactical_order = data["tactical_order"]

        # profile
        @preferred_foot = data["preferred_foot"]
        @birthdate = data["birthdate"]
        @height_in = data["height_in"]
        @weight_lb = data["weight_lb"]
        @height_cm = data["height_cm"]
        @weight_kg = data["weight_kg"]
        @teams = data["teams"]["team"].map {|team| Sportradar::Api::Soccer::Team.new team } if data["teams"]

        @statistics = OpenStruct.new data["statistics"] if data["statistics"]
        @response = data
      end

      def position_name
        positions = {"G" => "Goalie", "D" => "Defender", "M" => "Midfielder", "F" => "Forward"}
        positions[position] if position
      end

      def tactical_position_name
        tactical_positions = { "0" => "Unknown", "1" => "Goalkeeper", "2" => "Right back", "3" => "Central defender", "4" => "Left back", "5" => "Right winger", "6" => "Central midfielder", "7" => "Left winger", "8" => "Forward" }
        tactical_positions[tactical_position] if tactical_position
      end
    end
  end
end
