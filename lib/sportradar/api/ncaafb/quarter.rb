module Sportradar
  module Api
    class Ncaafb
      class Quarter < Data
        attr_accessor :response, :id, :number, :sequence, :home_points, :away_points, :drives

        def initialize(data, **opts)
          @response = data
          @api      = opts[:api]
          @game     = opts[:game]

          @id       = response["id"]
          @number   = response['number']
          @event    = response['event']

          # @number = data["number"]
          # @sequence = data["sequence"]
          # @home_points = data["home_points"]
          # # @home_points = response['scoring']['home']['points'] # from play_by_play
          # @away_points = data["away_points"]
          # # @away_points = response['scoring']['away']['points'] # from play_by_play
          # @drives = parse_into_array(selector: response["play_by_play"]["drive"], klass: Sportradar::Api::Nfl::Drive) if response["play_by_play"] && response["play_by_play"]["drive"]
        end

        def drives
          @drives ||= parse_into_array_with_options(selector: response['drive'], klass: Sportradar::Api::Ncaafb::Drive, api: @api, quarter: self)
        end
        def plays
          @plays ||= drives.flat_map(&:plays)
        end

        private

      end
    end
  end
end
