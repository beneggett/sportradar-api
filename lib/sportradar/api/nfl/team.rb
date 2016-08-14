module Sportradar
  module Api
    class Nfl::Team < Data
      attr_accessor :response, :id, :name, :alias, :game_number, :defense, :special_teams, :offense, :players, :statistics, :team_records, :player_records, :market, :franchise, :venue, :hierarchy, :coaches, :players, :used_timeouts, :remaining_timeouts, :points, :wins, :losses, :ties, :win_pct, :rank

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

        @defense = data["defense"]["position"].map {|position| Sportradar::Api::Nfl::Position.new position } if data["defense"] && data["defense"]["position"]
        @offense = data["offense"]["position"].map {|position| Sportradar::Api::Nfl::Position.new position } if data["offense"] && data["offense"]["position"]
        @special_teams = data["special_teams"]["position"].map {|position| Sportradar::Api::Nfl::Position.new position } if data["special_teams"] && data["special_teams"]["position"]
        @statistics = OpenStruct.new data["statistics"] if data["statistics"] # TODO Implement better?
        @team_records = OpenStruct.new data["team_records"] if data["team_records"] # TODO Implement better?
        @player_records = OpenStruct.new data["player_records"] if data["player_records"] # TODO Implement better?

        set_players
        set_coaches
      end

      def full_name
        [market, name].join(' ')
      end

      def record
        if wins && losses && ties
          "#{wins}-#{losses}" << (ties == '0' ? '' : "-#{ties}")
        end
      end

      private

      def set_players
        if response["player"]
          if response["player"].is_a?(Array)
            @players = response["player"].map {|player| Sportradar::Api::Nfl::Player.new player }
          elsif response["player"].is_a?(Hash)
            @players = [ Sportradar::Api::Nfl::Player.new(response["player"]) ]
          end
        elsif response["players"] && response["players"]["player"]
          if response["players"]["player"].is_a?(Array)
            @players = response["players"]["player"].map {|player| Sportradar::Api::Nfl::Player.new player }
          elsif response["players"]["player"].is_a?(Hash)
            @players = [ Sportradar::Api::Nfl::Player.new(response["players"]["player"]) ]
          end
        end
      end

      def set_coaches
        if response["coaches"] && response["coaches"]["coach"]
          if response["coaches"]["coach"].is_a?(Array)
            @coaches = response["coaches"]["coach"].map {|coach| Sportradar::Api::Nfl::Coach.new coach }
          elsif response["coaches"]["coach"].is_a?(Hash)
            @coaches = [ Sportradar::Api::Nfl::Coach.new(response["coaches"]["coach"]) ]
          end
        end
      end

    end
  end
end
