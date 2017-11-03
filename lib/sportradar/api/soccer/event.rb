module Sportradar
  module Api
    module Soccer
      class Event < Data
        attr_reader :id, :type, :time, :period, :period_type, :period_name, :match_time, :team, :x, :y, :outcome, :home_score, :away_score, :goal_scorer, :stoppage_time, :player_out, :player_in, :player

        def initialize(data, **opts)
          @response       = data
          @id             = data["id"]

          update(data, **opts)
        end

        def update(data, **opts)
          @type           = data['type']                        if data['type']
          @time           = Time.parse(data['time'])            if data['time']
          @period         = data['period']                      if data['period']
          @period_type    = data['period_type']                 if data['period_type']
          @period_name    = data['period_name']                 if data['period_name']
          @match_time     = data['match_time']                  if data['match_time']
          @team           = data['team']                        if data['team']
          @x              = data['x']                           if data['x']
          @y              = data['y']                           if data['y']
          @outcome        = data['outcome']                     if data['outcome']
          @home_score     = data['home_score']                  if data['home_score']
          @away_score     = data['away_score']                  if data['away_score']
          @commentaries   = data['commentaries']                if data['commentaries']
          @goal_scorer    = OpenStruct.new(data['goal_scorer']) if data['goal_scorer']
          @stoppage_time  = data['stoppage_time'].to_i          if data['stoppage_time']
          @player_out     = OpenStruct.new(data['player_out'])  if data['player_out']
          @player_in      = OpenStruct.new(data['player_in'])   if data['player_in']
          @player         = OpenStruct.new(data['player'])      if data['player'] # red/yellow cards
        end

        def updated
          @time
        end

        def minute
          @match_time
        end

      end
    end
  end
end
