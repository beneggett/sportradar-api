module Sportradar
  module Api
    module Football
      class Play < Data
        attr_accessor :response, :id, :sequence, :reference, :clock, :home_points, :away_points, :type, :play_clock, :wall_clock, :start_situation, :end_situation, :description, :alt_description, :statistics, :score, :scoring_play, :team_id, :player_id, :play_type, :players, :down, :yfd, :player_data

        def initialize(data, **opts)
          @response          = data
          @id                = data["id"]

          update(data, **opts)
        end

        def update(data, **opts)
          @api              = opts[:api] || @api
          @drive            = opts[:drive] || @drive
          @description      = data["description"] || data['summary'] || @description
          @alt_description  = data['alt_description'] if data['alt_description']
          @away_points  = data['away_points']  if data['away_points']
          @home_points  = data['home_points']  if data['home_points']

          @end_situation   = Sportradar::Api::Football::Situation.new(data["end_situation"])   if data["end_situation"]
          @start_situation = Sportradar::Api::Football::Situation.new(data["start_situation"]) if data["start_situation"]

          @team_id           = end_situation.team_id if end_situation
          @play_clock        = data["play_clock"]
          @reference         = data["reference"]
          @score             = data["score"]
          @scoring_play      = data["scoring_play"]
          @sequence          = data["sequence"]

          @clock        = data["clock"]        if data["clock"]
          @type         = data["type"]         if data["type"]
          @summary      = data["summary"]      if data["summary"]
          @updated      = data["updated"]      if data["updated"]
          @side         = data["side"]         if data["side"]
          @yard_line    = data["yard_line"]    if data["yard_line"]
          @down         = data["down"]         if data["down"]
          @yfd          = data["yfd"]          if data["yfd"]
          @formation    = data["formation"]    if data["formation"]
          @direction    = data["direction"]    if data["direction"]
          @distance     = data["distance"]     if data["distance"]
          @participants = data["participants"] if data["participants"]
          @play_type    = data["play_type"]    if data["play_type"]
          @sequence     = data["sequence"]     if data["sequence"]

          @deleted      = data["deleted"] || @deleted

          @details           = data["details"].gsub('.json', '') if data["details"]

          if data['statistics']
            @statistics = Sportradar::Api::Football::PlayStatistics.new(data['statistics'])
          elsif data['players']
            @player_data = data['players']
            @statistics = Sportradar::Api::Football::PlayStatistics.new(data['players'])
          else
            @statistics ||= OpenStruct.new(players: [])
          end
          parse_player
          @wall_clock        = data["wall_clock"]

          self
        end

        def players
          statistics.players
        end

        def deleted?
          !!@deleted
        end

        def start_spot
          start_situation&.spot
        end

        def end_spot
          end_situation&.spot
        end

        def down_distance
          [down, yfd].compact.join(' & ')
        end

        def end_of_regulation?
          false
        end

        def halftime?
          false
        end

        def parsed_ending
          @parsed_ending ||= search_for_drive_end
        end

        def search_for_drive_end
          case @play_type
          when 'kick'
            nil
          when 'rush'
            # check for fumble
            parse_description_for_drive_end
          when 'pass'
            # check for fumble/interception
            parse_description_for_drive_end
          when 'punt'
            parse_description_for_drive_end
          when 'penalty'
            nil
          when 'fieldgoal'
            parse_description_for_drive_end # nullified plays still have FG
          when 'extrapoint'
            :pat
          else
            parse_description_for_drive_end
          end
        end

        def parse_description_for_drive_end
          parsed_ending = case @description
          when /no play/i
            nil
          when /intercepted/i
            :interception
          when /fumbles/i
            :fumble
          when /extra point is good/i
            :touchdown
          # when missed extra point
          when /punts/i
            :punt
          when /Field Goal is No Good. blocked/i
            :fg
          when /Field Goal is No Good/i
            :fg
          # when missed field goal
          when /Field Goal is Good/i
            :fg
          when "End of 1st Half"
            :end_of_half
          else
            #
          end
          if parsed_ending
            parsed_ending
          end
        end

        def parse_player
          # TODO: Currently there is an issue where we are only mapping one player_id to a play, but there are plays with multiple players involved.
          play_stats = @statistics.penalty || @statistics.rush || @statistics.return || @statistics.receive
          if play_stats.is_a?(Array)
            play_stats = play_stats.first
          end
          @player_id = play_stats&.player&.id
        end
      end

    end
  end
end

__END__

ncaafb = Marshal.load(File.binread('ncaafb.bin'));
g = ncaafb.games.first;
res = g.get_pbp;
g.plays.count
g.plays.map(&:type)
g.plays.select {|p| p.type == 'event' } # => find the commercial breaks

sr = Sportradar::Api::Nfl.new
sch = sr.schedule(2016);
sch.weeks.count
sch.weeks.first.class
sch.weeks.first.games.size
sch.weeks.first.games.first;
sg = sch.weeks.first.games.first;
sg
pbp = sr.play_by_play(sg.id);
pbp.drives.size
pbp.drives.flat_map(&:plays)
pbp.drives.flat_map(&:plays).first.response
pbp.drives.flat_map(&:events).compact
pbp.drives.flat_map(&:plays).map(&:type)
g.drives.select {|d| d.type == 'event' }
g.plays.select {|p| p.type == 'event' }.size
g.plays.select {|p| p.type == 'event' }.map(&:description)
