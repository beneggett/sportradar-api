module Sportradar
  module Api
    module Baseball
      class Event
        class Lineup < Data
          attr_accessor :response, :id, :hitter_id, :outcome, :description

          def initialize(data, **opts)
            @response     = data
            # @api          = opts[:api]
            # @half_inning  = opts[:half_inning]
            @event    = opts[:event]

            @id       = data["id"]
            # @type     = data['type']

            update(data)
          end

          def update(data, **opts)
            @description = data['description'] if data['description']
          end

          def data_key
            'lineup'
          end


          {"lineup"=>{"description"=>"Brandon Kintzler (P) replaces Matt Belisle (P).", "id"=>"ad7357db-117e-4454-8d44-418ef64aa275", "player_id"=>"e0d89956-1427-4b2f-9025-10330561e464", "order"=>0, "position"=>1, "team_id"=>"aa34e0ed-f342-4ec6-b774-c79b47b60e2d", "last_name"=>"Kintzler", "first_name"=>"Brandon", "preferred_name"=>"Brandon", "jersey_number"=>"27"}}
          {"lineup"=>{"description"=>"Domingo Santana pinch-hitting for Rob Scahill.", "id"=>"4d232302-defe-4ed9-a1fc-4ef44e871138", "player_id"=>"d80a8b1f-aee7-400c-b21f-75e0ac4a32a2", "order"=>9, "position"=>11, "team_id"=>"dcfd5266-00ce-442c-bc09-264cd20cf455", "last_name"=>"Santana", "first_name"=>"Domingo", "preferred_name"=>"Domingo", "jersey_number"=>"16"}}

        end
      end
    end
  end
end
