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
          @type           = data['type']
          @time           = Time.parse(data['time']) if data['time']
          @period         = data['period']
          @period_type    = data['period_type']
          @period_name    = data['period_name']
          @match_time     = data['match_time']
          @team           = data['team'] # home/away
          @x              = data['x']
          @y              = data['y']
          @outcome        = data['outcome']
          @home_score     = data['home_score']
          @away_score     = data['away_score']
          @goal_scorer    = OpenStruct.new(data['goal_scorer']) if data['goal_scorer']
          @stoppage_time  = data['stoppage_time'].to_i          if data['stoppage_time']
          @player_out     = OpenStruct.new(data['player_out'])  if data['player_out']
          @player_in      = OpenStruct.new(data['player_in'])   if data['player_in']
          @player         = OpenStruct.new(data['player'])      if data['player'] # red/yellow cards
        end

        def minute
          @match_time
        end

      end
    end
  end
end
