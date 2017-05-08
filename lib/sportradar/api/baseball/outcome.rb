module Sportradar
  module Api
    module Baseball
      class Outcome < Data
        attr_accessor :response, :type, :current_inning, :current_inning_half, :count, :hitter, :pitcher, :runners

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @game     = opts[:game]
          
          @scores = {}
          @id = data['id']
          
          update(data, **opts)
        end

        def update(data, source: nil, **opts)
          update_from_outcome(data['outcome']) if data['outcome']
        end

        def update_from_outcome(data)
          @type                 = data['type']                 if data['type']
          @current_inning       = data['current_inning']       if data['current_inning']
          @current_inning_half  = data['current_inning_half']  if data['current_inning_half']
          @count                = data['count']                if data['count']
          @hitter               = data['hitter']               if data['hitter']
          @pitcher              = data['pitcher']              if data['pitcher']
          @runners              = data['runners']              if data['runners']
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

# inprogress data from daily summary
{"id"=>"e1b6d4cc-74f0-4f80-b1d4-d506624d7ba0",
 "status"=>"inprogress",
 "coverage"=>"full",
 "game_number"=>1,
 "day_night"=>"D",
 "scheduled"=>"2017-05-04T17:10:00+00:00",
 "home_team"=>"aa34e0ed-f342-4ec6-b774-c79b47b60e2d",
 "away_team"=>"27a59d3b-ff7c-48ea-b016-4798f560f5e1",
 "venue"=>{"id"=>"302f8dcd-eed6-4b83-8609-81548d51e955", "name"=>"Target Field", "market"=>"Minnesota", "capacity"=>39021, "surface"=>"grass", "address"=>"353 N 5th Street", "city"=>"Minneapolis", "state"=>"MN", "zip"=>"55403", "country"=>"USA"},
 "broadcast"=>{"network"=>"FS-N"},
 "outcome"=>
  {"type"=>"pitch",
   "current_inning"=>3,
   "current_inning_half"=>"B",
   "count"=>{"strikes"=>2, "balls"=>0, "outs"=>1, "inning"=>3, "inning_half"=>"B", "half_over"=>false},
   "hitter"=>{"id"=>"aecc630f-57da-4b23-842b-fd65394e81be", "outcome_id"=>"kF", "ab_over"=>false, "last_name"=>"Sano", "first_name"=>"Miguel", "preferred_name"=>"Miguel", "jersey_number"=>"22"},
   "pitcher"=>{"id"=>"c1f19b5a-9dee-4053-9cad-ee4196f921e1", "last_name"=>"Cotton", "first_name"=>"Jharel", "preferred_name"=>"Jharel", "jersey_number"=>"45", "pitch_type"=>"FA", "pitch_speed"=>90.0, "pitch_zone"=>9, "pitch_x"=>52, "pitch_y"=>-39},
   "runners"=>[{"id"=>"29a80d91-946d-4701-af7d-034850bdef00", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"", "out"=>false, "last_name"=>"Dozier", "first_name"=>"James", "preferred_name"=>"Brian", "jersey_number"=>"2"}]},
 "officials"=>
  [{"full_name"=>"Mike Winters", "first_name"=>"Mike", "last_name"=>"Winters", "assignment"=>"2B", "experience"=>"24", "id"=>"344565d2-3276-4948-ac8e-28e4e49be9d9"},
   {"full_name"=>"Mark Wegner", "first_name"=>"Mark", "last_name"=>"Wegner", "assignment"=>"3B", "experience"=>"15", "id"=>"27109ca4-3484-45ad-a78d-1a639c1bfabd"},
   {"full_name"=>"Marty Foster", "first_name"=>"Marty", "last_name"=>"Foster", "assignment"=>"1B", "experience"=>"15", "id"=>"af6b8841-0bfd-402b-88de-1439d7d4ea74"},
   {"full_name"=>"Mike Muchlinski", "first_name"=>"Mike", "last_name"=>"Muchlinski", "assignment"=>"HP", "experience"=>"2", "id"=>"ef45c7e3-9136-4704-b3a6-bfbd61cf9416"}]}