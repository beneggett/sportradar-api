module Sportradar
  module Api
    class Nfl::Team < Data
      attr_accessor :response, :id, :name, :alias, :game_number, :defense, :special_teams, :offense, :players, :statistics, :team_records, :player_records, :market, :franchise, :venue, :hierarchy, :coaches, :players, :used_timeouts, :remaining_timeouts, :points, :wins, :losses, :ties, :win_pct, :rank, :stats, :depth_chart

      alias_method :score, :points

      def initialize(data)
        @response = data
        @id = data["id"]
        @name = data["name"]
        @alias = data["alias"]
        @game_number = data["game_number"]
        @market = data["market"]

        # These come from boxscore summary
        @used_timeouts = data["used_timeouts"]
        @remaining_timeouts = data["remaining_timeouts"]
        @points = data["points"]

        @franchise = Sportradar::Api::Nfl::Franchise.new data["franchise"] if data["franchise"]
        @venue = Sportradar::Api::Nfl::Venue.new data["venue"] if data["venue"]
        @hierarchy = Sportradar::Api::Nfl::Hierarchy.new data["hierarchy"] if data["hierarchy"]

        @wins = data["wins"]
        @losses = data["losses"]
        @losses = data["losses"]
        @ties = data["ties"]
        @win_pct = data["win_pct"].to_f if data["win_pct"]
        @rank = data["rank"]

        @statistics = OpenStruct.new data["statistics"] if data["statistics"] # TODO Implement better?
        @team_records = OpenStruct.new data["team_records"] if data["team_records"] # TODO Implement better?
        @player_records = OpenStruct.new data["player_records"] if data["player_records"] # TODO Implement better?

        @defense = parse_into_array(selector: data["defense"]["position"], klass: Sportradar::Api::Nfl::Position)  if data["defense"] && data["defense"]["position"]
        @offense = parse_into_array(selector: data["offense"]["position"], klass: Sportradar::Api::Nfl::Position)  if data["offense"] && data["offense"]["position"]
        @special_teams = parse_into_array(selector: data["special_teams"]["position"], klass: Sportradar::Api::Nfl::Position)  if data["special_teams"] && data["special_teams"]["position"]
        @coaches = parse_into_array(selector: response["coaches"]["coach"], klass: Sportradar::Api::Nfl::Coach)  if response["coaches"] && response["coaches"]["coach"]
        @players = parse_into_array(selector: response["player"], klass: Sportradar::Api::Nfl::Player)  if response["player"]
        @players ||= parse_into_array(selector: response["players"]["player"], klass: Sportradar::Api::Nfl::Player)  if response["players"] && response["players"]["player"]
      end

      def full_name
        [market, name].join(' ')
      end

      def record
        if wins && losses && ties
          "#{wins}-#{losses}" << (ties == '0' ? '' : "-#{ties}")
        end
      end

    end
  end
end
