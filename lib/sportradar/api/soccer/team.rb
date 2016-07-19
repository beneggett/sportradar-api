module Sportradar
  module Api
    class Soccer::Team

      attr_accessor :id, :name, :full_name, :alias, :country_code, :country, :type, :reference_id, :formation, :score, :regular_score, :penalty_score, :winner, :scoring, :statistics, :first_half_score, :second_half_score, :players, :manager, :roster, :jersey_number, :position, :is_player, :is_manager, :response

      def initialize(data)
        @id = data["id"]
        @reference_id = data["reference_id"]
        @id = data["id"]
        @name = data["name"]
        @full_name = data["full_name"]
        @alias = data["alias"]
        @country_code = data["country_code"]
        @country = data["country"]
        @type = data["type"]
        @reference_id = data["reference_id"]
        @formation =  data["formation"]
        @score =  data["score"]
        @regular_score =  data["regular_score"]
        @penalty_score =  data["penalty_score"]
        @winner =  data["winner"]
        @scoring =  OpenStruct.new data["scoring"]
        @first_half_score = data["scoring"]["half"].find {|x| x["number"] == "1"}["points"] if data["scoring"]
        @second_half_score = data["scoring"]["half"].find {|x| x["number"] == "2"}["points"] if data["scoring"]
        @statistics =  OpenStruct.new data["statistics"] if data["statistics"]
        @players = data["players"]["player"].map {|player| Sportradar::Api::Soccer::Player.new player } if data["players"]

        @players = data["roster"]["player"].map {|player| Sportradar::Api::Soccer::Player.new player } if data["roster"]
        @manager =  Sportradar::Api::Soccer::Player.new data["manager"] if data["manager"]

        # player teams info
        @jersey_number = data["jersey_number"]
        @position = data["position"]
        @is_player = data["is_player"]
        @is_manager = data["is_manager"]

        @response = data
      end

      alias_method :roster, :players

    end
  end
end
