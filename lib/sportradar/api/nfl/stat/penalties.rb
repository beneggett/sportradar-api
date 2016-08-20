module Sportradar
  module Api
    class Nfl::Stat::Penalties < Nfl::StatPack
      attr_accessor :penalties, :yards

      alias :count :penalties

      def set_stats
        @response  = response[1] if response.is_a? Array
        @penalties = response['penalties']
        @yards     = response['yards']    
      end
      def formatted # do we care about using `#display` as the name? it's semantically accurate
        "#{count}-#{yards}"
      end
    end

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
