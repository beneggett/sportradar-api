module Sportradar
  module Api
    class Football::StatPack::Penalties < Football::StatPack
      attr_accessor :penalties, :yards

      alias :count :penalties

      def set_stats
        @response  = (response.dig(1) || {}) if response.is_a? Array
        @penalties = response.dig('penalties')
        @yards     = response.dig('yards')
      end
      def formatted
        "#{count}-#{yards}"
      end
    end

  end
end

# # sample response
# example_penalty_hash =
#   ["7",
#     {"player"=>
#       [{"name"=>"Curtis Grant",
#         "jersey"=>"58",
#         "reference"=>"00-0032084",
#         "id"=>"b807020d-d9c8-4fd0-9acb-fb61ddffae50",
#         "position"=>"LB",
#         "penalties"=>"1",
#         "yards"=>"5"},
#         # ...
#       ],
#     "penalties"=>"7",
#     "yards"=>"58"
#   }
# ]
