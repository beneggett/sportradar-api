module Sportradar
  module Api
    class Nfl::Game < Data
      attr_accessor :response, :id, :status, :reference, :number, :scheduled, :entry_mode, :venue, :home, :away, :broadcast, :number, :attendance, :utc_offset, :weather, :clock, :quarter, :summary, :situation, :last_event, :scoring, :scoring_drives, :quarters, :stats, :week, :season, :overtime

      def initialize(data)
        @response = data
        @id = data["id"]

        @status = data["status"]
        @reference = data["reference"]
        @number = data["number"]
        @scheduled = Time.parse(data["scheduled"]) if data["scheduled"]
        @week = Sportradar::Api::Nfl::Week.new data.dig("summary", "week") if data.dig("summary", "week")
        @season = Sportradar::Api::Nfl::Season.new data.dig("summary", "season") if data.dig("summary", "season")
        @entry_mode = data["entry_mode"]

        # game boxscore
        @number = data["number"]
        @attendance = data["attendance"]
        @utc_offset = data["utc_offset"]
        @weather = data["weather"]
        @clock = data["clock"]

        if data["quarter"]
          @quarter = data["quarter"][0]
          quarter_data = data["quarter"][1].is_a?(Hash) ? data["quarter"][1..-1] : data["quarter"][1]
          @quarters = quarter_data&.map { |hash| Sportradar::Api::Nfl::Quarter.new(hash) }
        end

        if data["overtime"]
          @overtime = parse_into_array(selector: data['overtime'], klass: Sportradar::Api::Nfl::Quarter)
          @quarters.concat(@overtime)
        end

        @summary = Sportradar::Api::Nfl::Summary.new data["summary"] if data["summary"]
        @situation = Sportradar::Api::Nfl::Situation.new data["situation"] if data["situation"]
        @last_event = Sportradar::Api::Nfl::Event.new data["last_event"]["event"] if data["last_event"] && data["last_event"]["event"]
        @scoring = Sportradar::Api::Nfl::Scoring.new data["scoring"] if data["scoring"]

        @scoring_drives = parse_into_array(selector: response["scoring_drives"]["drive"], klass: Sportradar::Api::Nfl::Drive)  if response["scoring_drives"] && response["scoring_drives"]["drive"]

        location = data["summary"] || data
        @venue = Sportradar::Api::Nfl::Venue.new data["venue"] || location["venue"] if data["venue"] || location["venue"]
        @home = Sportradar::Api::Nfl::Team.new   data["home"]  || location["home"]  if data["home"]  || location["home"]
        @away = Sportradar::Api::Nfl::Team.new   data["away"]  || location["away"]  if data["away"]  || location["away"]

        @broadcast = Sportradar::Api::Nfl::Broadcast.new data["broadcast"] if data["broadcast"]

        if data["team"]
          @stats = data["team"].map { |team_stat| [team_stat["id"], Sportradar::Api::Nfl::GameStatistic.new(team_stat)] }.to_h
          @home.stats = @stats[@home.id]
          @away.stats = @stats[@away.id]
        end

      end

      def overtime?
        !overtime.nil?
      end

      def full_name
        "#{away.full_name} vs #{home.full_name}"
      end

      def name
        "#{away.name} vs #{home.name}"
      end
      def started?
        ['inprogress', 'halftime', 'delayed'].include?(status)
      end
      def finished?
        status == "closed"
      end

      def sport_league
        'NFL'.freeze
      end

      def current_score
        "#{summary.home.points}-#{summary.away.points}" if summary
      end

      def drives
        @drives ||= begin
          drives = Array(quarters&.flat_map(&:drives)).compact
          # Scan for duplicates
          drives.each_cons(2) do |a,b|
            # Merge plays and events into the first if duplicate and flag dup for removal
            if a.id == b.id
              a.plays.concat(b.plays)
              Array(a.events).concat(Array(b.events)).uniq!
              b.id = nil
            end
          end
          # Remove the dup
          drives.delete_if{ |d| d.id.nil? }
        end
      end

      def plays
        Array(drives&.flat_map(&:plays)).compact
      end

      def status_description
        status_description = {
           "scheduled" => "The game is currently scheduled to occur.",
           "inprogress" => "The game is currently in progress.",
           "halftime" => "The game is currently at the half.",
           "complete" => "The game is over, but the statistics validation process has not been completed.",
           "closed" => "The game is over and the game statistics have been validated.",
           "cancelled" => "The game has been cancelled.",
           "postponed" => "The scheduled game has been postponed for some reason.",
           "delayed" => "The scheduled game, or a game that was in progress, is now delayed for some reason.",
           "flex-schedule" => "The game is currently scheduled to occur on a specific date and time, however, it will more than likely be moved to a different time for broadcast purposes.",
           "time-tbd" => "The game is scheduled to occur, the date is known, but the start time has not been determined.",
         }
         status_descriptions[status] if status
      end

    end
  end
end
