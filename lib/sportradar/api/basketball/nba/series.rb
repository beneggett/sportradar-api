module Sportradar
  module Api
    module Basketball
      class Nba
        class Series < Basketball::Season
          attr_accessor :response, :id, :status, :title, :round, :start_date
          alias :name :title

          def initialize(data, **opts)
            @response = data
            @api      = opts[:api]

            @id         = data['id']
            @games_hash = {}
            @participants_hash = {}

            update(data, **opts)
          end

          def update(data, **opts)
            @title      = data['title']       if data['title']
            @round      = data['round']       if data['round']
            @status     = data['status']      if data['status']
            @start_date = data['start_date']  if data['start_date']


            update_participants(data['participants']) if data['participants']
            update_games(data['games'])               if data['games']
          end

          def games
            @games_hash.values
          end

          def update_games(data)
            create_data(@games_hash, data, klass: Game, api: @api, series: self)
          end

          def participants
            @participants_hash.values
          end

          def update_participants(data)
            create_data(@participants_hash, data, klass: Team, api: @api, series: self)
          end

          def scheduled
            games.first&.scheduled
          end

          # status helpers
          def future?
            ['scheduled', 'delayed', 'created', 'time-tbd'].include? status
          end
          def started?
            ['inprogress', 'halftime', 'delayed'].include? status
          end
          def finished?
            ['complete', 'closed'].include? status
          end
          def completed?
            'complete' == status
          end
          def closed?
            'closed' == status
          end

        end
      end
    end
  end
end

__END__

sd = sr.daily_schedule;
sr = Sportradar::Api::Basketball::Nba.new
ss = sr.standings;
ss = sr.schedule;
ss = sr.schedule(2015, 'pst)');
