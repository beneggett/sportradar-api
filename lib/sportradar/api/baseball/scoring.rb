module Sportradar
  module Api
    module Baseball
      class Scoring < Data
        attr_accessor :response, :api, :id, :home, :away, :scores

        def initialize(data, **opts)
          @api      = opts[:api]
          @game     = opts[:game]
          
          @scores = Hash.new { |hash, key| hash[key] = {} }
          @id = data['id']
          
          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          new_scores = case source
          when :box
            parse_from_box(data)
          when :pbp
            parse_from_pbp(data)
          when :summary
            parse_from_box(data)
          when :rhe
            data
          else
            # if data['quarter'] || data['half']
            #   parse_from_pbp(data)
            # elsif data['team']
            #   parse_from_box(data)
            # else # schedule requests
            #   {}
            # end
            {}
          end
          # parse data structure
          # handle data from team (all quarters)
          # handle data from quarter (both teams)
          # handle data from game?
          @scores.each { |k, v| v.merge!(new_scores.delete(k) || {} ) }
          new_scores.each { |k, v| @scores.merge!(k => v) }
        end

        def points(team_id)
          @score[team_id].to_i
        end


        private

        def parse_from_pbp(data)
          scoring = data['innings'].map {|i| i['scoring'] }.compact
          return {} if scoring.empty?
          scoring.each_with_object({}).with_index(1) do |(hash, memo), idx|
            memo[idx] = {hash.dig('home', 'id') => hash.dig('home', 'runs'), hash.dig('away', 'id') => hash.dig('away', 'runs')}
          end
        end

        def parse_from_box(data)
          id = data.dig('home', 'id')
          da = data.dig('home', 'scoring')
          return {} unless da
          da.each { |h| h[id] = h.delete('runs') }
          id = data.dig('away', 'id')
          db = data.dig('away', 'scoring')
          return {} unless db
          db.each { |h| h[id] = h.delete('runs') }
          da.zip(db).map{ |a, b| [a['sequence'].to_i, a.merge(b)] }.sort{ |(a,_), (b,_)| a <=> b }.to_h
        end

        def parse_from_summary(data)
          # 
        end

      end
    end
  end
end
