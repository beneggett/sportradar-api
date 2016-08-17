module Sportradar
  module Api
    class Nfl::Stat::Penalties < Nfl::StatPack
      def set_stats(data)
        data = data[1] if data.is_a? Array
        @penalties = data['penalties']
        @yard      = data['yards']    
      end
    end

    example_penalty_hash =
      ["7",
        {"player"=>
          [{"name"=>"Curtis Grant",
            "jersey"=>"58",
            "reference"=>"00-0032084",
            "id"=>"b807020d-d9c8-4fd0-9acb-fb61ddffae50",
            "position"=>"LB",
            "penalties"=>"1",
            "yards"=>"5"},
            # ...
          ],
        "penalties"=>"7",
        "yards"=>"58"
      }
    ]

  end
end