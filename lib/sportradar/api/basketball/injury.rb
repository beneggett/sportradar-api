module Sportradar
  module Api
    module Basketball
      class Injury < Data
        attr_accessor :response, :id, :comment, :descripton, :status, :start_date, :update_date

        def initialize(data, **opts)
          @response = data
          update(data, **opts)
        end

        def update(data, **opts)
          @id           = data.dig(0, 'id')
          @comment      = data.dig(0, 'comment')
          @descripton   = data.dig(0, 'desc')
          @status       = data.dig(0, 'status')
          @start_date   = data.dig(0, 'start_date')
          @update_date  = data.dig(0, 'update_date')
        end

        def out?
          @status == 'Out'
        end

        private def sample_data
          {
            "injury" => {
              "id"         => "069a9d3f-036e-4dab-9b49-d2e75082230e",
              "comment"    => "Paul will have surgery to repair torn ligaments in his left thumb and is expected to be out for six-to-eight weeks to recover, according to a report from ESPN.com.",
              "desc"       => "Thumb",
              "status"     => "Out",
              "start_date" => "2017-01-17",
              "update_date"=> "2017-01-17"
            }
          }
        end

      end
    end
  end
end
