module Sportradar
  module Api
    class Nfl::Injury < Data
      attr_accessor :response, :status, :status_date, :practice, :primary

      def initialize(data)
        @response = data
        @status = data["status"]
        @status_date = data["status_date"]
        @practice = OpenStruct.new data["practice"] if data['practice']
        @primary = data["primary"]
      end

    end
  end
end
