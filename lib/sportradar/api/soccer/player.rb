module Sportradar
  module Api
    module Soccer
      class Player < Data

        attr_reader :id, :league_group, :name, :type, :nationality, :country_code, :height, :weight, :jersey_number, :preferred_foot, :stats, :game_stats, :date_of_birth, :matches_played
        alias :position :type

        def initialize(data = {}, league_group: nil, **opts)
          @response     = data
          @id           = data['id'] if data['id']
          @api          = opts[:api]
          @team         = opts[:team]

          @league_group = league_group || data['league_group'] || @api&.league_group

          update(data, **opts)
        end

        def update(data, **opts)
          @id             = data['id']             if data['id']
          @league_group = opts[:league_group] || data['league_group'] || @league_group

          if data['player']
            update(data['player'])
          end

          @name           = data['name']           if data['name']
          @last_name      = data['last_name']      if data['last_name']
          @first_name     = data['first_name']     if data['first_name']
          @type           = data['type']           if data['type']
          @nationality    = data['nationality']    if data['nationality']
          @country_code   = data['country_code']   if data['country_code']
          @height         = data['height']         if data['height']
          @weight         = data['weight']         if data['weight']
          @jersey_number  = data['jersey_number']  if data['jersey_number']
          @preferred_foot = data['preferred_foot'] if data['preferred_foot']
          @matches_played = data['matches_played'] if data['matches_played']
          @stats          = data['statistics']     if data['statistics']
          @date_of_birth  = Date.parse(data['date_of_birth']) if data['date_of_birth']
          set_game_stats(data)

          @team.update_player_stats(self, data['statistics']) if data['statistics'] && @team
          if opts[:match]
            @team.update_player_stats(self, data, opts[:match])
          end

        end

        def set_game_stats(data)
          @game_stats ||= {}

          @game_stats[:substituted_in] = data['substituted_in'] if data['substituted_in'].present?
          @game_stats[:substituted_out] = data['substituted_out'] if data['substituted_out'].present?
          @game_stats[:goals_scored] = data['goals_scored'] if data['goals_scored'].present?
          @game_stats[:assists] = data['assists'] if data['assists'].present?
          @game_stats[:own_goals] = data['own_goals'] if data['own_goals'].present?
          @game_stats[:yellow_cards] = data['yellow_cards'] if data['yellow_cards'].present?
          @game_stats[:yellow_red_cards] = data['yellow_red_cards'] if data['yellow_red_cards'].present?
          @game_stats[:red_cards] = data['red_cards'] if data['red_cards'].present?
          @game_stats[:goal_line_clearances] = data['goal_line_clearances'] if data['goal_line_clearances'].present?
          @game_stats[:interceptions] = data['interceptions'] if data['interceptions'].present?
          @game_stats[:chances_created] = data['chances_created'] if data['chances_created'].present?
          @game_stats[:crosses_successful] = data['crosses_successful'] if data['crosses_successful'].present?
          @game_stats[:crosses_total] = data['crosses_total'] if data['crosses_total'].present?
          @game_stats[:passes_short_successful] = data['passes_short_successful'] if data['passes_short_successful'].present?
          @game_stats[:passes_medium_successful] = data['passes_medium_successful'] if data['passes_medium_successful'].present?
          @game_stats[:passes_long_successful] = data['passes_long_successful'] if data['passes_long_successful'].present?
          @game_stats[:passes_short_total] = data['passes_short_total'] if data['passes_short_total'].present?
          @game_stats[:passes_medium_total] = data['passes_medium_total'] if data['passes_medium_total'].present?
          @game_stats[:passes_long_total] = data['passes_long_total'] if data['passes_long_total'].present?
          @game_stats[:duels_header_successful] = data['duels_header_successful'] if data['duels_header_successful'].present?
          @game_stats[:duels_sprint_successful] = data['duels_sprint_successful'] if data['duels_sprint_successful'].present?
          @game_stats[:duels_tackle_successful] = data['duels_tackle_successful'] if data['duels_tackle_successful'].present?
          @game_stats[:duels_header_total] = data['duels_header_total'] if data['duels_header_total'].present?
          @game_stats[:duels_sprint_total] = data['duels_sprint_total'] if data['duels_sprint_total'].present?
          @game_stats[:duels_tackle_total] = data['duels_tackle_total'] if data['duels_tackle_total'].present?
          @game_stats[:goals_conceded] = data['goals_conceded'] if data['goals_conceded'].present?
          @game_stats[:shots_faced_saved] = data['shots_faced_saved'] if data['shots_faced_saved'].present?
          @game_stats[:shots_faced_total] = data['shots_faced_total'] if data['shots_faced_total'].present?
          @game_stats[:penalties_faced] = data['penalties_faced'] if data['penalties_faced'].present?
          @game_stats[:penalties_saved] = data['penalties_saved'] if data['penalties_saved'].present?
          @game_stats[:fouls_committed] = data['fouls_committed'] if data['fouls_committed'].present?
          @game_stats[:was_fouled] = data['was_fouled'] if data['was_fouled'].present?
          @game_stats[:offsides] = data['offsides'] if data['offsides'].present?
          @game_stats[:shots_on_goal] = data['shots_on_goal'] if data['shots_on_goal'].present?
          @game_stats[:shots_off_goal] = data['shots_off_goal'] if data['shots_off_goal'].present?
          @game_stats[:shots_blocked] = data['shots_blocked'] if data['shots_blocked'].present?
          @game_stats[:minutes_played] = data['minutes_played'] if data['minutes_played'].present?
          @game_stats[:performance_score] = data['performance_score'] if data['performance_score'].present?
          @game_stats[:goals_by_head] = data['goals_by_head'] if data['goals_by_head'].present?
          @game_stats[:goals_by_penalty] = data['goals_by_penalty'] if data['goals_by_penalty'].present?
        end

        def display_name
          @name || [@first_name, @last_name].join(' ')
        end

        def first_name
          @name.split()[1]
        end

        def last_name
          @name.split()[0].delete(',')
        end

        def api
          @api || Sportradar::Api::Soccer::Api.new(league_group: @league_group)
        end

        def path_base
          "players/#{ id }"
        end

        def path_profile
          "#{ path_base }/profile"
        end
        def get_profile
          data = api.get_data(path_profile).to_h
          ingest_profile(data)
        end
        def ingest_profile(data)
          update(data)
          data
        end
        def queue_profile
          url, headers, options, timeout = api.get_request_info(path_profile)
          {url: url, headers: headers, params: options, timeout: timeout, callback: method(:ingest_profile)}
        end
      end
    end
  end
end
