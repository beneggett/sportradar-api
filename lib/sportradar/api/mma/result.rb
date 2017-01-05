module Sportradar
  module Api
    class Mma
      class Result < Data
        attr_accessor :response, :id, :round, :time, :outcome, :submission, :endstrike, :endtarget, :endposition, :winner, :draw

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @fight    = opts[:fight]
          @scores_hash = {}


          update(data)
        end

        def scores
          @scores_hash.values
        end
        def add_score(score)
          @scores_hash[score.id] = score if score
        end


        def update(data, **opts)
          @round       = data['round']       if data['round']       # "3",
          @time        = data['time']        if data['time']        # "05:00",
          @outcome     = data['method']      if data['method']      # "Decision - Split",
          @submission  = data['submission']  if data['submission']  # "",
          @endstrike   = data['endstrike']   if data['endstrike']   # "",
          @endtarget   = data['endtarget']   if data['endtarget']   # "",
          @endposition = data['endposition'] if data['endposition'] # "",
          @winner      = data['winner']      if data['winner']      # "3043fe6a-1f8b-4aa7-85fe-8f8859740cc4",
          @draw        = data['draw']        if data['draw']        # "false",

          update_scores(data)
          self
        end
        def update_scores(data)
          return if String === data['scores']
          create_data(@scores_hash, data.dig('scores', 'judge'), klass: Score, api: api, result: self)
          # @judges  = Judge.new(data['judges'], fight: self, api: api)    if data['judges']
        end

        def api
          @api ||= Sportradar::Api::Mma.new
        end

      end
    end
  end
end

__END__


m = Sportradar::Api::Mma.new
sr = m.participants;
f = sr.fighters.sample;


m = Sportradar::Api::Mma.new
sc = m.schedule;
e = sc.events.sample;
e.fights.first.fighters.first.born

fighter_hash = {'id' => "259117dc-c443-4086-8c1d-abd082e3d4b9" } # => Conor McGregor
f = Sportradar::Api::Mma::Fighter.new(fighter_hash)