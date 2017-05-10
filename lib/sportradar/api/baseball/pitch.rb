module Sportradar
  module Api
    module Baseball
      class Pitch < Data
        attr_accessor :response, :id, :at_bat, :outcome_id, :status, :count, :is_ab_over, :warming_up, :runners

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @at_bat   = opts[:at_bat]
          # @half_inning   = opts[:half_inning]

          @id       = data["id"]

          update(data)
        end
        def ==(other)
          @id == other.id && @count == other.count && @outcome_id == other.outcome_id
        end
        def update(data, **opts)

          @outcome_id   = data['outcome_id']    if data['outcome_id']
          @description  = data['description']   if data['description']
          @status       = data['status']        if data['status']

          parse_hit(data)
          parse_runners(data['runners'])        if data['runners']
          parse_pitcher(data['pitcher'])        if data['pitcher']
          parse_flags(data['flags'])            if data['flags']
          parse_count(data['count'])            if data['count']
          parse_warming_up(data['warming_up'])  if data['warming_up']
          parse_fielders(data['fielders'])      if data['fielders']
          parse_errors(data['errors'])          if data['errors']
        end

        def pitches
          @pitches_hash.values
        end

        def parse_hit(data)
          @hit_type     = data['hit_type']      if data['hit_type']
          @hit_location = data['hit_location']  if data['hit_location']
        end

        def parse_runners(data)
          @runners = data.map { |hash| Runner.new(hash) }
        end

        def parse_errors(data)
          @runners = data.map { |hash| Error.new(hash) }
        end

        def parse_fielders(data)
          @fielders = data.map { |hash| Fielder.new(hash) }
        end

        def parse_pitcher(data)
          @type         = data['pitch_type']   if data['pitch_type']
          @speed        = data['pitch_speed']  if data['pitch_speed']
          @x            = data['pitch_x']      if data['pitch_x']
          @y            = data['pitch_y']      if data['pitch_y']
          @zone         = data['pitch_zone']   if data['pitch_zone']

          @total_pitch_count = data['pitch_count'] if data['pitch_count']
        end

        def parse_flags(data)
          @is_ab_over     = data['is_ab_over']       if data['is_ab_over']
          @is_bunt        = data['is_bunt']          if data['is_bunt']
          @is_bunt_shown  = data['is_bunt_shown']    if data['is_bunt_shown']
          @is_hit         = data['is_hit']           if data['is_hit']
          @is_wild_pitch  = data['is_wild_pitch']    if data['is_wild_pitch']
          @is_passed_ball = data['is_passed_ball']   if data['is_passed_ball']
          @is_double_play = data['is_double_play']   if data['is_double_play']
          @is_triple_play = data['is_triple_play']   if data['is_triple_play']
        end

        def parse_count(data)
          @count              = data
          @balls              = data['balls']        if data['balls']
          @strikes            = data['strikes']      if data['strikes']
          @outs               = data['outs']         if data['outs']
          @atbat_pitch_count  = data['pitch_count']  if data['pitch_count']
        end

        def parse_warming_up(data)
          @warming_id             = data['id']
          @warming_player_id      = data['player_id']
          @warming_team_id        = data['team_id']
          @warming_last_name      = data['last_name']
          @warming_first_name     = data['first_name']
          @warming_preferred_name = data['preferred_name']
          @warming_jersey_number  = data['jersey_number']
          @warming_up             = "#{data['preferred_name'] || data['first_name']} #{data['last_name']}"
          puts data unless data['last_name']
        end

        def parse_steal(data)
          
        end

        {"type"=>"steal", "id"=>"76762fd9-683c-42f2-8c72-8d9fd4f5bc7b", "status"=>"official", "created_at"=>"2017-05-06T02:56:49+00:00", "pitcher"=>{"id"=>"9dd06397-4353-44e8-81bb-6e88a75e42b5"}, "runners"=>[{"id"=>"3e39fe20-6dca-4894-807b-1ce76ff93e29", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"", "out"=>false, "last_name"=>"Owings", "first_name"=>"Christopher", "preferred_name"=>"Chris", "jersey_number"=>"16"}]}

        {"type"=>"steal", "id"=>"df01b116-afcd-467f-9b9c-99d3891629c6", "status"=>"official", "created_at"=>"2017-05-06T03:00:58+00:00", "pitcher"=>{"id"=>"90fb6719-5135-42f3-88c0-0ccde448368c"}, "runners"=>[{"id"=>"106e6fb6-6460-412e-abdb-9f73469a27b9", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"DeShields", "first_name"=>"Delino", "preferred_name"=>"Delino", "jersey_number"=>"3"}]}
        {"type"=>"steal", "id"=>"37c9192d-cac9-4320-b721-f68955eecf24", "status"=>"official", "created_at"=>"2017-05-06T03:02:16+00:00", "pitcher"=>{"id"=>"90fb6719-5135-42f3-88c0-0ccde448368c"}, "runners"=>[{"id"=>"106e6fb6-6460-412e-abdb-9f73469a27b9", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"DeShields", "first_name"=>"Delino", "preferred_name"=>"Delino", "jersey_number"=>"3"}]}
        {"type"=>"steal", "id"=>"b8dcebfa-e02c-470e-ba73-e9b6b553cc0d", "status"=>"official", "created_at"=>"2017-05-06T03:38:48+00:00", "pitcher"=>{"id"=>"1a2638a3-28df-46b3-9cca-0f8eb29b581f"}, "runners"=>[{"id"=>"2847c4e0-01be-46bd-992e-701ee447e3f5", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"Upton", "first_name"=>"Justin", "preferred_name"=>"Justin", "jersey_number"=>"8"}, {"id"=>"f27a7574-57db-4eeb-8f88-377048806de2", "starting_base"=>3, "ending_base"=>3, "outcome_id"=>"", "out"=>false, "last_name"=>"Martínez", "first_name"=>"Victor", "preferred_name"=>"Victor", "jersey_number"=>"41"}]}

      end
    end
  end
end
