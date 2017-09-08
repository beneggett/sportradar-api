module Sportradar
  module Api
    module Football
      class Scoring < Data
        attr_accessor :response, :api, :id, :home, :away, :scores

        def initialize(data, **opts)
          @api      = opts[:api]
          @game     = opts[:game]
          
          @scores = {}
          @id = data['id']
          
          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          new_scores = case source
          when :box
            parse_from_box(data)
          when :extended_box
            parse_from_box(data)
          when :pbp
            parse_from_pbp(data)
          when :summary
            parse_from_summary(data)
          when :statistics
            parse_from_statistics(data)
          else
            if data['quarter'] || data['half']
              parse_from_pbp(data)
            elsif data['team']
              parse_from_box(data)
            else # schedule requests
              {}
            end
          end
          @scores.each { |k, v| v.merge!(new_scores.delete(k) || {} ) }
          new_scores.each { |k, v| @scores.merge!(k => v) }
        end

        def points(team_id)
          @score[team_id].to_i
        end


        private

        def parse_from_box(data)
          # home
          id = data.dig('home_team', 'id')
          da = data.dig('home_team', 'scoring')
          return {} unless da
          home = da.map { |h| [h['quarter'].to_i, { id => h['points'].to_i }] }.to_h
          # away
          id = data.dig('away_team', 'id')
          da = data.dig('away_team', 'scoring')
          return {} unless da
          away = da.map { |h| [h['quarter'].to_i, { id => h['points'].to_i }] }.to_h

          home.each { |quarter, hash| hash.merge!(away[quarter]) }
        end

        def parse_from_statistics(data)
          {}
        end

        def parse_from_pbp(data)
          return {} unless data['periods']
          quarters = data['periods']
          overtimes = Array(data['overtime'])
          data = (quarters + overtimes).compact.map{|q| q['scoring'] }
          data.map.with_index(1) { |h, i| [i, { h.dig('home', 'id') => h.dig('home', 'points').to_i, h.dig('away', 'id') => h.dig('away', 'points').to_i }] }.to_h
        end

        # def period_name
        #   'quarter'
        # end

        def parse_from_summary(data)
          {} # nothing for college
        end

      end
    end
  end
end
