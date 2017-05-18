module Sportradar
  module Api
    module Baseball
      class Pitch < Data
        attr_accessor :response, :id, :at_bat, :outcome_id, :status, :count, :is_ab_over, :is_hit, :warming_up, :runners, :errors, :pitch_type_name, :x, :y, :zone, :total_pitch_count, :atbat_pitch_count, :speed, :outcome, :hit_type, :balls, :strikes, :outs

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

          if data['outcome_id']
            @outcome_id   = data['outcome_id']
            @outcome      = self.class.pitch_outcome(@outcome_id)
          end
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

        def foul?
          ['kF','kFT'].include? @outcome_id
        end

        def hit_ends_ab?
          @hit_location.present? && !foul?
        end

        def parse_hit(data)
          @hit_type     = data['hit_type']      if data['hit_type']
          @hit_location = data['hit_location']  if data['hit_location']
        end

        def parse_runners(data)
          @runners = data.map { |hash| Runner.new(hash) }
        end

        def parse_errors(data)
          @errors = data.map { |hash| Error.new(hash) }
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

          @pitch_type_name = self.class.pitch_type(@type)
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
        end

        def parse_steal(data)

        end

        {"type"=>"steal", "id"=>"76762fd9-683c-42f2-8c72-8d9fd4f5bc7b", "status"=>"official", "created_at"=>"2017-05-06T02:56:49+00:00", "pitcher"=>{"id"=>"9dd06397-4353-44e8-81bb-6e88a75e42b5"}, "runners"=>[{"id"=>"3e39fe20-6dca-4894-807b-1ce76ff93e29", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"", "out"=>false, "last_name"=>"Owings", "first_name"=>"Christopher", "preferred_name"=>"Chris", "jersey_number"=>"16"}]}

        {"type"=>"steal", "id"=>"df01b116-afcd-467f-9b9c-99d3891629c6", "status"=>"official", "created_at"=>"2017-05-06T03:00:58+00:00", "pitcher"=>{"id"=>"90fb6719-5135-42f3-88c0-0ccde448368c"}, "runners"=>[{"id"=>"106e6fb6-6460-412e-abdb-9f73469a27b9", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"DeShields", "first_name"=>"Delino", "preferred_name"=>"Delino", "jersey_number"=>"3"}]}
        {"type"=>"steal", "id"=>"37c9192d-cac9-4320-b721-f68955eecf24", "status"=>"official", "created_at"=>"2017-05-06T03:02:16+00:00", "pitcher"=>{"id"=>"90fb6719-5135-42f3-88c0-0ccde448368c"}, "runners"=>[{"id"=>"106e6fb6-6460-412e-abdb-9f73469a27b9", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"DeShields", "first_name"=>"Delino", "preferred_name"=>"Delino", "jersey_number"=>"3"}]}
        {"type"=>"steal", "id"=>"b8dcebfa-e02c-470e-ba73-e9b6b553cc0d", "status"=>"official", "created_at"=>"2017-05-06T03:38:48+00:00", "pitcher"=>{"id"=>"1a2638a3-28df-46b3-9cca-0f8eb29b581f"}, "runners"=>[{"id"=>"2847c4e0-01be-46bd-992e-701ee447e3f5", "starting_base"=>1, "ending_base"=>1, "outcome_id"=>"CK", "out"=>false, "last_name"=>"Upton", "first_name"=>"Justin", "preferred_name"=>"Justin", "jersey_number"=>"8"}, {"id"=>"f27a7574-57db-4eeb-8f88-377048806de2", "starting_base"=>3, "ending_base"=>3, "outcome_id"=>"", "out"=>false, "last_name"=>"Martínez", "first_name"=>"Victor", "preferred_name"=>"Victor", "jersey_number"=>"41"}]}


        def self.pitch_type(code)
          pitch_types[code]
        end
        def self.pitch_types
          @pitch_types ||= {
            'FA' => 'Fastball',
            'SI' => 'Sinker',
            'CT' => 'Cutter',
            'CU' => 'Curveball',
            'SL' => 'Slider',
            'CH' => 'Changeup',
            'KN' => 'Knuckleball',
            'SP' => 'Splitter',
            'SC' => 'Screwball',
            'FO' => 'Forkball',
            'IB' => 'Intentional Ball',
            'PI' => 'Pitchout',
          }
        end
        def self.pitch_outcome(code)
          pitch_outcomes[code]
        end
        def self.pitch_outcomes
          @pitch_outcomes ||= {
            'aBK'     => 'Balk',
            'aCI'     => 'Catcher Interference',
            'aD'      => 'Double',
            'aDAD3'   => 'Double - Adv 3rd',
            'aDAD4'   => 'Double - Adv Home',
            'aFCAD2'  => 'Fielders Choice - Adv 2nd',
            'aFCAD3'  => 'Fielders Choice - Adv 3rd',
            'aFCAD4'  => 'Fielders Choice - Adv Home',
            'aHBP'    => 'Hit By Pitch',
            'aHR'     => 'Homerun',
            'aIBB'    => 'Intentional Walk',
            'aKLAD1'  => 'Strike Looking - Adv 1st',
            'aKLAD2'  => 'Strike Looking - Adv 2nd',
            'aKLAD3'  => 'Strike Looking - Adv 3rd',
            'aKLAD4'  => 'Strike Looking - Adv Home',
            'aKSAD1'  => 'Strike Swinging - Adv 1st',
            'aKSAD2'  => 'Strike Swinging - Adv 2nd',
            'aKSAD3'  => 'Strike Swinging - Adv 3rd',
            'aKSAD4'  => 'Strike Swinging - Adv Home',
            'aROE'    => 'Reached On Error',
            'aROEAD2' => 'Reached On Error - Adv 2nd',
            'aROEAD3' => 'Reached On Error - Adv 3rd',
            'aROEAD4' => 'Reached On Error - Adv Home',
            'aS'      => 'Single',
            'aSAD2'   => 'Single - Adv 2nd',
            'aSAD3'   => 'Single - Adv 3rd',
            'aSAD4'   => 'Single - Adv Home',
            'aSBAD1'  => 'Sacrifice Bunt - Adv 1st',
            'aSBAD2'  => 'Sacrifice Bunt - Adv 2nd',
            'aSBAD3'  => 'Sacrifice Bunt - Adv 3rd',
            'aSBAD4'  => 'Sacrifice Bunt - Adv Home',
            'aSFAD1'  => 'Sacrifice Fly - Adv 1st',
            'aSFAD2'  => 'Sacrifice Fly - Adv 2nd',
            'aSFAD3'  => 'Sacrifice Fly - Adv 3rd',
            'aSFAD4'  => 'Sacrifice Fly - Adv Home',
            'aT'      => 'Triple',
            'aTAD4'   => 'Triple - Adv Home',
            'bAB'     => 'Enforced Ball',
            'bB'      => 'Ball',
            'bDB'     => 'Dirt Ball',
            'bIB'     => 'Intentional Ball',
            'bPO'     => 'Pitchout',
            'kF'      => 'Foul Ball',
            'kFT'     => 'Foul Tip',
            'kKL'     => 'Strike Looking',
            'kKS'     => 'Strike Swinging',
            'oBI'     => 'Hitter Interference',
            'oDT3'    => 'Double - Out at 3rd',
            'oDT4'    => 'Double - Out at Home',
            'oFC'     => 'Fielders Choice',
            'oFCT2'   => 'Fielders Choice - Out at 2nd',
            'oFCT3'   => 'Fielders Choice - Out at 3rd',
            'oFCT4'   => 'Fielders Choice - Out at Home',
            'oFO'     => 'Fly Out',
            'oGO'     => 'Ground Out',
            'oKLT1'   => 'Strike Looking - Out at 1st',
            'oKLT2'   => 'Strike Looking - Out at 2nd',
            'oKLT3'   => 'Strike Looking - Out at 3rd',
            'oKLT4'   => 'Strike Looking - Out at Home',
            'oKST1'   => 'Strike Swinging - Out at 1st',
            'oKST2'   => 'Strike Swinging - Out at 2nd',
            'oKST3'   => 'Strike Swinging - Out at 3rd',
            'oKST4'   => 'Strike Swinging - Out at Home',
            'oLO'     => 'Line Out',
            'oOBB'    => 'Out of Batters Box',
            'oOP'     => 'Out on Appeal',
            'oPO'     => 'Pop Out',
            'oROET2'  => 'Reached On Error - Out at 2nd',
            'oROET3'  => 'Reached On Error - Out at 3rd',
            'oROET4'  => 'Reached On Error - Out at Home',
            'oSB'     => 'Sacrifice Bunt',
            'oSBT2'   => 'Sacrifice Bunt - Out at 2nd',
            'oSBT3'   => 'Sacrifice Bunt - Out at 3rd',
            'oSBT4'   => 'Sacrifice Bunt - Out at Home',
            'oSF'     => 'Sacrifice Fly',
            'oSFT2'   => 'Sacrifice Fly - Out at 2nd',
            'oSFT3'   => 'Sacrifice Fly - Out at 3rd',
            'oSFT4'   => 'Sacrifice Fly - Out at Home',
            'oST2'    => 'Single - Out at 2nd',
            'oST3'    => 'Single - Out at 3rd',
            'oST4'    => 'Single - Out at Home',
            'oTT4'    => 'Triple - Out at Home',
          }
        end
        {"type"=>"steal", "id"=>"01ead210-1586-4d07-9713-6fd3d17b2b4c", "status"=>"official", "created_at"=>"2017-05-15T23:55:53+00:00", "pitcher"=>{"id"=>"9c12832b-c487-40d4-915b-e44097632d7c"}, "runners"=>[{"id"=>"65de4cd1-ca86-468c-9346-1e68d6279a8e", "starting_base"=>1, "ending_base"=>0, "outcome_id"=>"PO", "out"=>true, "last_name"=>"Gordon", "first_name"=>"Devaris", "preferred_name"=>"Dee", "jersey_number"=>"9", "description"=>"Dee Gordon picked off.", "fielders"=>[{"id"=>"bd519b9f-7539-4282-a741-3bd2bf532c40", "type"=>"putout", "sequence"=>1, "last_name"=>"Gurriel", "first_name"=>"Yulieski", "preferred_name"=>"Yulieski", "jersey_number"=>"10"}, {"id"=>"9c12832b-c487-40d4-915b-e44097632d7c", "type"=>"assist", "sequence"=>1, "last_name"=>"Musgrove", "first_name"=>"Joseph", "preferred_name"=>"Joe", "jersey_number"=>"59"}]}]}
      end
    end
  end
end
