module Sportradar
  module Api
    class Rank
      def initialize(data)
        @id        = data['id']
        @name      = data['name']
        @market    = data['market']
        @rank      = data['rank']
        @wins      = data['wins']
        @losses    = data['losses']
        @prev_rank = data['prev_rank']
        @points    = data['points'] || data['votes']
        @fp_votes  = data['fp_votes'].to_i
        if data['rpi']
          @rpi = data
        end
      end
    end
    class Poll
      def initialize(data)        
        @response = data

        @id       = data.dig('poll', 'id')
        @name     = data.dig('poll', 'name')
        @alias    = data.dig('poll', 'alias')
        @week     = data['week']
        @year     = data['year']
        @time     = data['effective_date']

        update(data)
      end
      def update(data)
        @ranked = data['rankings'].map { |h| Rank.new(h) }
        if @alias == 'AP' || @alias == 'US'
          @votes = data['candidates'].map.with_index(@ranked.size + 1) { |h, i| Rank.new(h.merge('rank' => i)) }
        end
      end
    end
  end
end
