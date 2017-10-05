module Sportradar
  module Api
    class Soccer::Team < Data
      attr_accessor :response, :id, :name, :full_name, :alias, :country_code, :country, :type, :reference_id, :formation, :score, :regular_score, :penalty_score, :winner, :scoring, :statistics, :first_half_score, :second_half_score, :players, :manager, :roster, :jersey_number, :position, :is_player, :is_manager,  :rank, :win, :draw, :loss, :goals_for, :goals_against, :points, :change, :goals_diff, :jersey_number, :position, :is_player, :is_manager, :home, :away


      def initialize(data)
        @response = data
        @id = data["id"]
        @reference_id = data["reference_id"]
        @name = data["name"]
        @full_name = data["full_name"] || data["name"]
        @alias = data["alias"]
        @country_code = data["country_code"]
        @country = data["country"]
        @type = data["type"]
        @formation =  data["formation"]
        @score =  data["score"]
        @regular_score =  data["regular_score"]
        @penalty_score =  data["penalty_score"]
        @winner =  data["winner"]
        @rank = data["rank"]
        @win = data["win"]
        @draw = data["draw"]
        @loss = data["loss"]
        @goals_for = data["goals_for"]
        @goals_against = data["goals_against"]
        @points = data["points"]
        @change = data["change"]
        @goals_diff = data["goals_diff"]
        @jersey_number = data["jersey_number"]
        @position = data["position"]
        @is_player = data["is_player"]
        @is_manager = data["is_manager"]

        # Standings generate these
        @home = OpenStruct.new data["home"] if data["home"]
        @away = OpenStruct.new data["away"] if data["away"]

        @scoring =  OpenStruct.new data["scoring"] if data["scoring"]
        parse_scoring if scoring

        @statistics =  OpenStruct.new data["statistics"] if data["statistics"]
        @players = parse_into_array(selector: data["players"]["player"], klass: Sportradar::Api::Soccer::Player)  if response['players'] && response['players']['player']
        @players = parse_into_array(selector: data["roster"]["player"], klass: Sportradar::Api::Soccer::Player)  if response['roster'] && response['roster']['player']
        @manager =  Sportradar::Api::Soccer::Player.new data["manager"] if data["manager"]
      end

      alias_method :roster, :players

      private

      def parse_scoring
        if scoring.half.is_a?(Array)
          @first_half_score = scoring.half.find {|x| x["number"] == "1"}["points"]
          @second_half_score = scoring.half.find {|x| x["number"] == "2"}["points"]
        elsif scoring.half.is_a?(Hash)
          @first_half_score = scoring.half["points"]
        end
      end
    end
  end
end
