module Sportradar
  module Api
    module Basketball
      class Ncaamb
        class Division < Data
          attr_accessor :response, :id, :name, :alias

          def initialize(data, **opts)
            # @response = data
            @api      = opts[:api]

            @id = data["id"]
            update(data, **opts)
          end

          def update(data, **opts)
            @name = data["name"]
            @alias = data["alias"]
            @conferences_hash = create_data({}, data["conference"], klass: Conference, division: self, api: @api) if data["conference"]
          end

          def conferences
            @conferences_hash.values
          end

          def conference(code_name)
            conferences_by_name[code_name]
          end

          def conferences_by_name
            @conferences_by_name ||= conferences.map { |c| [c.alias, c] }.to_h
          end

          def teams
            conferences.flat_map(&:teams)
          end

        end
      end
    end
  end
end
