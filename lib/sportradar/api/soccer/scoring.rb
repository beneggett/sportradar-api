module Sportradar
  module Api
    module Soccer
      class Scoring < Data
        attr_accessor :response, :api, :id, :home, :away, :scores

        def initialize(data, **opts)
          @api      = opts[:api]
          @match    = opts[:match]
          
          @scores = {}
          @id = data['id']
          
          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          # new_scores = case source
          # when :box
          #   parse_from_box(data)
          # when :timeline
          #   parse_from_timeline(data)
          # when :summary
          #   parse_from_box(data)
          # else
          #   if data['period'] || data['half']
          #     parse_from_timeline(data)
          #   elsif data['team']
          #     parse_from_box(data)
          #   else # schedule requests
          #     {}
          #   end
          # end
          new_scores = parse_from_timeline(data)
          # parse data structure
          # handle data from team (all periods)
          # handle data from period (both teams)
          # handle data from match?
          @scores.each { |k, v| v.merge!(new_scores.delete(k) || {} ) }
          new_scores.each { |k, v| @scores.merge!(k => v) }
        end

        def goals(team_id)
          @score[team_id].to_i
        end


        private

        def parse_from_timeline(data)
          if data['period_scores']
            data['period_scores'].map do |hash|
              [hash["number"], {"home"=>hash['home_score'], "away"=>hash['away_score']}]
            end.to_h
          else
            {}
          end
        end

        # def period_name
        #   'period'
        # end

        def parse_from_summary(data)
          # 
        end

      end
    end
  end
end
